require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "sign_up" do
    mail = Notifications.sign_up
    assert_equal "Sign up", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "cancel_account" do
    mail = Notifications.cancel_account
    assert_equal "Cancel account", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
