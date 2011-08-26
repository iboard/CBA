# -*- encoding : utf-8 -*-

class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  referenced_in :user # The Sponsor

  # The invitee
  field   :name,          :required => true
  validates_presence_of   :name
  field   :email,         :index => true
  validates             :email, :presence => true, :email => true
  validates_uniqueness_of :email,  :case_sensitive => false
  field   :roles_mask,    :type => Fixnum, :default => 0
  field   :token,         :index => true
    validates_presence_of   :token
    validates_uniqueness_of :token
  field   :message,       :default => ""
  field   :accepted_at,   :type => Time
  field   :accepted_by,   :type => BSON::ObjectId

  # Filters
  before_validation  :generate_token
  after_create       :send_invitation



  private
  def generate_token
    self.token = String::random_string(10)
  end

  # Send an invitation by email as a delayed job
  # @param [Integer] arg[0] = invitation_id
  # @param [String] arg[1] = subject
  # @param [String] arg[2] = url_with_token
  # @param [String] arg[3] = message
  def send_invitation
     DelayedJob.enqueue('UserInviter',
       Time.now+10.second,
       self.id.to_s,
       I18n.translate(:you_are_invited_by, :name => self.user.name),
       self.message
     )
  end

end
