class NewPostingNotifier < Struct.new( :args )

  # arg[0] = blog_id
  # arg[1] = posting_id
  def perform
    Notifications::new_posting_created(args[0],args[1]).deliver
  end

end