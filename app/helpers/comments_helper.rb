module CommentsHelper 
  def commentable_path(comment, path_components)
    eval(
      "edit_"+path_components.map { |c| c.class.to_s.underscore }.join("_")+'_comment_path('+
      path_components.map { |c| "'#{c.id.to_s}'" }.join(",")+",'#{comment.id.to_s}')"
    )
  end
end

