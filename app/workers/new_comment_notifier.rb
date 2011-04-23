class NewCommentNotifier < Struct.new( :args )

  # arg[0] = recipient,
  # arg[1] = commentable.title,
  # arg[2] = email,
  # arg[3] = name,
  # arg[4] = comment
  # arg[5] = link to commentable
  def perform
    Notifications::new_comment_created(
      args[0], args[1], args[2],
      args[3], args[4], args[5]
    ).deliver
  end

end