class Notifications < ActionMailer::Base
  default :from => APPLICATION_CONFIG['registration_from']

  def sign_up(new_user)
    @user = new_user
    @notify_subject = "NEW SIGN UP AT #{APPLICATION_CONFIG['name']}"
    mail( :to => APPLICATION_CONFIG['admin_notification_address'], :subject => @notify_subject)
  end

  def cancel_account(user_info)
    @user_info = user_info
    @notify_subject = "USER CANCELED ACCOUNT AT #{APPLICATION_CONFIG['name']}"
    mail( :to => APPLICATION_CONFIG['admin_notification_address'], :subject => @notify_subject)
  end
end
