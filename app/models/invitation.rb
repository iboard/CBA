class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :user # The Sponsor
  
  # The invitee
  field   :name,          :required => true
    validates_presence_of   :name
  field   :email,         :index => true
    validates_presence_of   :email
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
  
  
  
  private
  def generate_token
    self.token = String::random_string(10)
  end
end
