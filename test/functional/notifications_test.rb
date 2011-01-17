require 'test_helper'


class NotificationsTest < ActionMailer::TestCase

  test "sign_up" do
    user = User.first
    mail = Notifications.sign_up(user)
    assert_equal "NEW SIGN UP AT TESTAPPLICATION", mail.subject
    assert_equal ['test@application.tt'], mail.to
    assert_equal ['test@application.tt'], mail.from
    assert_equal mail.body.encoded.include?(user.name), true
  end

  test "cancel_account" do
    mail = Notifications.cancel_account("SOME INFORMATION ABOUT THE USER")
    assert_equal "USER CANCELED ACCOUNT AT TESTAPPLICATION", mail.subject
    assert_equal ['test@application.tt'], mail.to
    assert_equal ['test@application.tt'], mail.from
    assert_equal mail.body.encoded.include?("SOME INFORMATION ABOUT THE USER"), true
  end

end
