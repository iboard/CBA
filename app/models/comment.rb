# Comment is a polymorphic class. Any 'commentable' can have comments.
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field  :name
  field  :email
  field  :comment

  validates             :email, :presence => true, :email => true
  validates_presence_of :name
  validates_presence_of :comment
  
  embedded_in :commentable, :inverse_of => :comments
  
  scope :since, lambda { |since| where(:created_at.gt => since) }   
  after_create :send_notification

  # Calculate the time left a user can edit a comment
  def time_left_to_edit
    @time_left_to_edit ||= CONSTANTS['max_time_to_edit_new_comments'].to_i - ( (Time.now()-self.updated_at )/1.minute ).to_i
  end


  def self.build_and_validate_comment(commentable, form_params)
    comment = commentable.comments.build(form_params)
    if comment.valid?
      comment.save
    else
      errors =  comment.errors.full_messages.join("<br/>").html_safe
    end
    [comment, errors]
  end

  
  private
  
  # TODO: Instead of application-name, send the class-name and title of the commentable
  def send_notification
    # arg[0] = commentable_identifier
    # arg[1] = comment_email
    # arg[2] = comment_name
    # arg[3] = comment_comment
    if self.commentable.respond_to?(:user)
      user = self.commentable.user
    end
    recipient = user ? user.email : APPLICATION_CONFIG['admin_notification_address']
    DelayedJob.enqueue('NewCommentNotifier',
      Time.now+10.second,
      recipient,
      self.commentable.title,
      self.email, 
      self.name, 
      self.comment
    )

  end


end