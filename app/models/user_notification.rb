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
      @recipients = User.any_in(email: new_value.split(",").map(&:strip)).all
    else
      @recipients = User.all
    end
  end
  
private

  # Copy the user_notification to all recipients but self (sender)
  def deliver_message
    return unless @recipients
    append_delivery_notes
    @recipients.reject{|r| r==self.user}.each do |usr|
      usr.user_notifications.create(self.attributes).save 
      usr.save
    end
    self.save!
    self.user.save!
  end
  
  # Append delivered to: All Users | list of users to the sender's copy of
  # the user_notification. Will be called from deliver_message. Don't call otherwise
  def append_delivery_notes
    self.message += "\n----\n" + I18n.translate(:delivered_to)
    if( all_users = (@recipients.count == User.count))
      self.message += I18n.translate(:all_users, count: @recipients.count)
    else
      self.message += @recipients.map { |recipient|
        recipient.name + " (#{recipient.email})"
      }.join(", ")
    end
  end
end
