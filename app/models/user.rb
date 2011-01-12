class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name
  field :roles_mask, :type => Fixnum, :default => 0
  field :use_gravatar, :type => Boolean, :default => true
  
  references_many :authentications, :dependent => :delete
  
  
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :roles,
                  :remember_me, :roles, :authentication_token, :confirmation_token,
                  :avatar, :clear_avatar, :crop_x, :crop_y, :crop_w, :crop_h,
                  :time_zone, :language, :use_gravatar
                  
  attr_accessor :clear_avatar
  
  has_attached_file :avatar,
                    :styles => { 
                      :medium => "300x300>",
                      :thumb  => "100x100>",
                      :icon   => "64x64"
                    },
                    :processors => [:cropper]
   attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
   after_update  :reprocess_avatar, :if => :cropping?
  
  # Roles
  ROLES = %w(confirmed_user moderator author maintainer admin)
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  
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

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
    Rails.logger.info("SET ROLES TO #{self.roles.inspect}")
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def role?(role)
    return roles.include? role.to_s unless role.is_a?(Array)
    my_roles = self.roles
    role.each do |r|
      return true if my_roles.include?(r.to_s)
    end
    return false
  end
  
  def clear_avatar
    false
  end
  
  def clear_avatar=(new_value)
    self.avatar = nil if new_value == '1'
  end
  
  # omniAuth
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    apply_trusted_services(omniauth) if self.new_record?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    super
  end
  
  def avatar_url(mode)
    if self.use_gravatar
      "http://gravatar.com/avatar/#{gravatar_id}.png?cache=#{self.updated_at.strftime('%Y%m%d%H%M%S')}"
    else
      avatar.url(mode)
    end
  end
  
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
    Digest::MD5.hexdigest(self.email.downcase)
  end
  
  def apply_trusted_services(omniauth)
    if self.name.blank?
      self.name = omniauth['user_info']['nickname'] unless omniauth['user_info']['nickname'].blank?
    end
    if self.email.blank?
      self.email = omniauth['user_info']['email'] unless omniauth['user_info']['email'].blank?
    end
    self.password, self.password_confirmation = String::random_string(20)
    self.confirmed_at, self.confirmation_sent_at = Time.now
  end

  def async_notify_on_creation
     Delayed::Job.enqueue NewUserNotifier.new(self.id,"NEW USER REGISTERED", ADMIN_EMAIL_ADDRESS)
  end  
  
  
end

