# -*- encoding : utf-8 -*-

# This is a Device-User-Class extended with ROLES, Avatar-handling, and more
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  cache

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name
  field :roles_mask, :type => Fixnum, :default => 0
  field :use_gravatar, :type => Boolean, :default => true
  field :invitation_id, :type => BSON::ObjectId
  def invitation
    @invitation ||= Invitation.criteria.for_ids(self.invitation_id).first
  end
  def invitation=(inv)
    @invitation = nil
    self.invitation_id = inv.id
  end

  references_many :authentications, :dependent => :delete
  references_many :postings, :dependent => :delete
  references_many :invitations, :dependent => :delete

  embeds_many :user_notifications
  has_many    :articles

  validates_presence_of   :name
  validates_presence_of   :email
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false

  attr_accessible :name, :email, :password, :password_confirmation, :roles_mask,
                  :remember_me, :authentication_token, :confirmation_token,
                  :avatar, :clear_avatar, :crop_x, :crop_y, :crop_w, :crop_h,
                  :time_zone, :language, :use_gravatar, :invitation_id

  attr_accessor :clear_avatar

  has_mongoid_attached_file :avatar,
                            :styles => {
                              :popup  => "800x600=",
                              :medium => "300x300>",
                              :thumb  => "100x100>",
                              :icon   => "64x64"
                            },
                            :processors => [:cropper]
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update  :reprocess_avatar, :if => :cropping?

  # Notifications
  after_create   :async_notify_on_creation
  before_destroy :async_notify_on_cancellation
  before_update  :notify_if_confirmed

  # Authentications
  after_create :save_new_authentication
  after_create :first_user_hook

  # Roles - Do not change the order and do not remove roles if you
  # already have productive data! Thou it's safe to append new roles
  # at the end of the string. And it's safe to rename roles in place
  ROLES = [:guest, :confirmed_user, :author, :moderator, :maintainer, :admin]

  scope :with_role, lambda { |role| { :where => {:roles_mask.gte => ROLES.index(role) } } }

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    paperclip_geometry avatar, style
  end

  def new_avatar?
    avatar.updated_at && ((Time::now() - Time::at(self.avatar.updated_at)) < 1.minute)
  end

  def admin?
    User.all.any? ? (self == User.first || role?(:admin)) : true
  end

  def role=(role)
    self.roles_mask = ROLES.index(role)
    Rails.logger.warn("SET ROLES TO #{self.roles_mask} FOR #{self.inspect}")
  end

  # return user's role as symbol.
  def role
    ROLES[roles_mask].to_sym
  end

  # Ask if the user has at least a specific role.
  #   @user.role?('admin')
  def role?(role)
    self.roles_mask >= ROLES.index(role.to_sym)
  end

  # virtual attribute needed for the view but is false always.
  def clear_avatar
    false
  end

  # clear a previous uploaded avatar-image.
  def clear_avatar=(new_value)
    self.avatar = nil if new_value == '1'
  end

  # fetch attributes from the omniauth-record.
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    apply_trusted_services(omniauth) if self.new_record?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  # remove the password and password-confirmation attribute if not needed.
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    super
  end

  # Remove an URL of the local avatar or the gravatar
  def avatar_url(mode)
    if self.use_gravatar
      "http://gravatar.com/avatar/#{gravatar_id}.png?cache=#{self.updated_at.strftime('%Y%m%d%H%M%S')}"
    else
      avatar.url(mode)
    end
  end

  # Link to the gravatar profile
  def gravatar_profile
    if self.use_gravatar
      "http://gravatar.com/#{gravatar_id}"
    end
  end

  private
  def reprocess_avatar
    avatar.reprocess!
  end

  def gravatar_id
    Digest::MD5.hexdigest(self.email.downcase) if self.email
  end

  def apply_trusted_services(omniauth)

    # Merge user_info && extra.user_info
    user_info = omniauth['user_info']
    if omniauth['extra'] && omniauth['extra']['user_hash']
      user_info.merge!(omniauth['extra']['user_hash'])
    end

    # try name or nickname
    if self.name.blank?
      self.name   = user_info['name']   unless user_info['name'].blank?
      self.name ||= user_info['nickname'] unless user_info['nickname'].blank?
      self.name ||= (user_info['first_name']+" "+user_info['last_name']) unless \
        user_info['first_name'].blank? || user_info['last_name'].blank?
    end

    if self.email.blank?
      self.email = user_info['email'] unless user_info['email'].blank?
    end

    # Set a random password for omniauthenticated users
    self.password, self.password_confirmation = String::random_string(20)
    self.confirmed_at, self.confirmation_sent_at = Time.now

    # Build a new Authentication and remember until :after_create -> save_new_authentication
    @new_auth = authentications.build( :uid => omniauth['uid'], :provider => omniauth['provider'])
  end

  # Called :after_create
  def save_new_authentication
    @new_auth.save unless @new_auth.nil?
  end

  # Inform admin about sign ups and cancellations of accounts
  def async_notify_on_creation
     DelayedJob.enqueue('NewSignUpNotifier', Time.now, self.id)
  end

  # Inform admin about cancellations of accounts
  def async_notify_on_cancellation
     DelayedJob.enqueue('CancelAccountNotifier', Time.now, self.inspect)
  end

  # Inform admin if someone confirms an account
  def notify_if_confirmed
    if attribute_changed?('confirmed_at')
      DelayedJob.enqueue('AccountConfirmedNotifier', Time.now, self.id)
    end
  end

  # If created user is first user, confirm and make admin
  def first_user_hook
    if User.count < 2
      self.confirmed_at = Time.now
      self.role=:admin
      self.save!
    end
  end

end

