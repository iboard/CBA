module CommentsHelper

  def commentable_show_path(commentable=nil)
    commentable ||= @commentable
    case(commentable.class)
    when Posting
      blog_posting_path(commentable.blog,commentable)
    else
      eval( "#{commentable.class.to_s.underscore}_path(commentable)")
    end
  end

end

