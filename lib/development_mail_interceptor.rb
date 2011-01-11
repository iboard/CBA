class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "DEVELOPMENT MAIL - #{message.to} #{message.subject}"
    message.to = DEVELOPMENT_MAIL_RECIPIENT
  end
end