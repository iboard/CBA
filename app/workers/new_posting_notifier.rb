class NewPostingNotifier < Struct.new( :args )
  
  # arg[0] = blog_id
  # arg[1] = posting_id
  def perform
    blog=Blog.find(args[0])
    posting = blog.postings.find(args[1])
    Notifications::new_posting_created(blog,posting).deliver
  end
  
end