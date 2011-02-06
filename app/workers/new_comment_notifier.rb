class NewCommentNotifier < Struct.new( :args )
  
  # arg[0] = commentable_identifier
  # arg[1] = comment_email
  # arg[2] = comment_name
  # arg[3] = comment_comment
  def perform
    Notifications::new_comment_created(args[0], args[1], args[2], args[3]).deliver
  end
  
end