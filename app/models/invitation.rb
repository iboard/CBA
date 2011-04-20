class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :user # The Sponsor
  
  # The invitee
  field   :name,        :required => true
  validates_presence_of :name
  field   :email,       :index => true
  validates_presence_of :email
  validates_uniqueness_of :email,  :case_sensitive => false  
  field   :roles_mask,  :type => Fixnum, :default => 0
  field   :accepted_at, :type => Time
  field   :accepted_by, :type => BSON::ObjectId
end
