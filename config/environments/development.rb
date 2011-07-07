Cba::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # next line remarked for 3.1     
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  ### ActionMailer Config
  config.action_mailer.default_url_options ||= { :host => DEFAULT_URL} 
  config.action_mailer.default_url_options[:host] = DEFAULT_URL
  
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"


  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
end
