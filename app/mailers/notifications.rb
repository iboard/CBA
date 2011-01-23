# Use this mailer to send notifications eg for newly created pages, sign ups
# and so on.
class Notifications < ActionMailer::Base

  default :from => APPLICATION_CONFIG['registration_from']

  # When a new users signed up inform the adminstrator
  def sign_up(new_user)
    @user = new_user
    @notify_subject = "NEW SIGN UP AT #{APPLICATION_CONFIG['name']}"
    mail( :to => APPLICATION_CONFIG['admin_notification_address'], :subject => @notify_subject)
  end

  # Inform the admin if a user will cancel the account.
  def cancel_account(user_info)
    @user_info = user_info
    @notify_subject = "USER CANCELED ACCOUNT AT #{APPLICATION_CONFIG['name']}"
    mail( :to => APPLICATION_CONFIG['admin_notification_address'], :subject => @notify_subject)
  end
end
