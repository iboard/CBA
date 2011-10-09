# -*- encoding : utf-8 -*-

# This is a Device-User-Class extended with ROLES, Avatar-handling, and more
class UserNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :deliver_message

  embedded_in :user

  field  :message
  field  :hidden, :type => Boolean, :default => false

  scope  :displayed, where(:hidden.ne => true)
  scope  :hidden,    where(:hidden => true)


  # virtual attributes
  def recipients
  end
  
  def recipients=(new_value)
    unless new_value.blank?
      @recipients = User.any_in(email: new_value.split(",")).all
    else
      @recipients = User.all
    end
  end
  
private
  def deliver_message
    return unless @recipients
    @recipients.each do |usr|
      usr.user_notifications.create(self.attributes) unless usr == self.user
    end
  end
end
