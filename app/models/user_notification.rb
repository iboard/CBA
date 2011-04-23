# This is a Device-User-Class extended with ROLES, Avatar-handling, and more
class UserNotification
  include Mongoid::Document
  include Mongoid::Timestamps
  cache
  
  embedded_in :user
  
  field  :message
  field  :hidden, :type => Boolean, :default => false
  
  scope  :displayed, where(:hidden.ne => true)
  scope  :hidden,    where(:hidden => true)
  
end
