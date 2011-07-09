# -*- encoding : utf-8 -*-

# moved to application.rb
# -> require File::dirname(__FILE__) + "/../mailserver_setting.rb"


require File::dirname(__FILE__) + "/../../lib/development_mail_interceptor.rb"

ActionMailer::Base.smtp_settings = {
  :address              => MAILSERVER_ADDRESS,
  :port                 => MAILSERVER_PORT,
  :domain               => MAILSERVER_DOMAIN,
  :user_name            => MAILSERVER_USERNAME,
  :password             => MAILSERVER_PASSWORD,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

Cba::Application.config.action_mailer.default_url_options[:host] = DEFAULT_URL
