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
  
  # Inform the admin if a user confirms an account
  def account_confirmed(user)
    @notify_subject = "USER CONFIRMED ACCOUNT AT #{APPLICATION_CONFIG['name']}"
    @user = user
    mail( :to => APPLICATION_CONFIG['admin_notification_address'], :subject => @notify_subject)
  end
  
  def new_posting_created(blog,posting)
    
    @posting = posting
    @blogtitle=blog.title
    @title   = posting.title
    @username= posting.user.name
    @content = RedCloth.new(posting.body).to_html.html_safe
    @url     = blog_posting_url(blog,posting)
    @notify_subject = "A NEW POSTING WAS CREATED AT #{APPLICATION_CONFIG['name']}"

    begin
      # Attach cover picture
      if posting.cover_picture_exists?
        if File.exist?(filename=posting.cover_picture.path)
          attachments[File::basename(filename)] = File.read(filename)
        end
      end
      
      # TODO: The following code doesn't work. Either there is a bug somewhere
      # TODO: in CBA or in Rails::Mail. Only the cover-pic arrives.
      # TODO: Check if it's possible to attach more files with Rails Mail - it should!
      ### # Attach attachments
      ### @content << "ATTACHMENTS"
      ### posting.attachments.each do |attachment|
      ###   if File.exist?(attachment.file.path)
      ###     @contetn << "ADDING #{attachment.file_file_name}, #{attachment.file.path}"
      ###     attachments[attachment.file_file_name] = File.read(attachment.file.path)
      ###   end
      ### end
    rescue => e
      msg = "<br/><br/>*** ERROR ATTACHING FILE #{e.to_s} **** #{__FILE__}:#{__LINE__}"
      @content += msg.html_safe
      puts msg
    end
    
    mail( :to => APPLICATION_CONFIG['admin_notification_address'], :subject => @notify_subject)
  end
  
end
