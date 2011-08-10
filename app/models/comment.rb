# -*- encoding : utf-8 -*-

# Comment is a polymorphic class. Any 'commentable' can have comments.
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  field  :name
  field  :email
  field  :comment
  field  :from_ip

  validates             :email, :presence => true, :email => true
  validates_presence_of :name
  validates_length_of   :name, :minimum => 1
  validates_presence_of :comment
  validates_length_of   :comment, :minimum => 1

  referenced_in :commentable, :inverse_of => :comments, :polymorphic => true

  scope :since, lambda { |since| where(:created_at.gt => since) }
  after_create :send_notification

  # Calculate the time left a user can edit a comment
  def time_left_to_edit
    unless self.new_record?
      @time_left_to_edit ||= CONSTANTS['max_time_to_edit_new_comments'].to_i - ( (Time.now()-self.updated_at )/1.minute ).to_i
    else
      -1
    end
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

  def update_session_comments(comments)
    begin
      remove_old_comments(comments) << [self.id.to_s,self.updated_at.to_i]
    rescue => e
      Rails.logger.warn(
        "***WARNING*** #{e.inspect} *** "+ "RESET SESSION COMMENTS "+
        "#{__FILE__}:#{__LINE__}"
      )
      [self.id.to_s,self.updated_at.to_i]
    end
  end

  def commentable_url
    path = "http://#{DEFAULT_URL}/"
    case self.commentable_type
    when Posting
      path += "blogs/#{self.commentable.blog_id.to_s}/postings/#{self.commentable_id}"
    else
      path += "#{self.commentable.class.to_s.pluralize.downcase}/#{self.commentable_id}"
    end
    path
  end
  
  def user
    User.where( :name => self.name, :email => self.email).first
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
      self.commentable.try(:title) || "(no title)",
      self.email,
      self.name,
      self.comment,
      self.commentable_url
    )
  end

  # Remove self and old comments from session (comments)
  def remove_old_comments(comments)
    (comments || []).reject { |r|
        (r[1].to_i < (Time.now-CONSTANTS['max_time_to_edit_new_comments'].to_i.minutes).to_i) ||
        r[0].to_s.eql?(self.id.to_s)
    }
  end

end