class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps
  
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
  
  def send_invitation
     # arg[0] = invitation_id
     # arg[1] = subject
     # arg[2] = url_with_token
     # arg[3] = message
     DelayedJob.enqueue('UserInviter',
       Time.now+10.second,
       self.id.to_s,
       I18n.translate(:you_are_invited_by, :name => self.user.name),
       self.message
     )
  end  
  
end
