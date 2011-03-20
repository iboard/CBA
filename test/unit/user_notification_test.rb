require 'test_helper'

class UserNotificationTest < ActiveSupport::TestCase
  
  def setup
    User.delete_all
  end
  
  def cleanup
    User.delete_all
  end
  
  # Replace this with your real tests.
  test "User should embed user_notifications" do
    user = Factory.build(:user)
    user.user_notifications << UserNotification.new(:message => "Your document was created successfully")
    user.user_notifications << UserNotification.new(:message => "Your second message")
    user.user_notifications << UserNotification.new(:message => "Your last message")
    user.save
    user.reload
    assert user.user_notifications.first.message == "Your document was created successfully", "Notification should be stored with user"
    assert user.user_notifications.second.message == "Your second message", "More notifications should be saved"
    assert user.user_notifications.last.message == "Your last message", "Ordering should be preserved and last added message should be messages.last"
  end
  
end