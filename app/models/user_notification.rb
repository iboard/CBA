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
  def deliver_message
    return unless @recipients
    self.message += "\n----\n" + I18n.translate(:delivered_to)
    if( all_users = (@recipients.count == User.count))
      self.message += I18n.translate(:all_users, count: @recipients.count)
    end
    @recipients.each do |usr|
      usr.user_notifications.create(self.attributes).save unless usr == self.user
      self.message += "\n *" + usr.name + " (#{usr.email})" unless all_users == true
      usr.save
    end
    self.save!
    self.user.save!
  end
end
