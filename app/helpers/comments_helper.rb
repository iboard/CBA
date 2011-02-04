module CommentsHelper 
  
  # Build the path for edit_commentables by path_components
  # eg. /page/:page_id/comments/:id
  # or. /blogs/:blog_id/postings/:posting_id/comments/:id
  def commentable_path(comment, path_components)
    eval(
      "edit_"         +
      
      # blogs_postings
      path_components.map { |c| 
        c.class.to_s.underscore 
      }.join("_")     +
      
      '_comment_path('+
      
      # Append the components as parameters
      path_components.map { |c| 
        "'#{c.id.to_s}'" 
      }.join(",")     +
      
      # Append the comment itself
      ",'#{comment.id.to_s}')"
    )
  end

end

