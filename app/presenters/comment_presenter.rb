class CommentPresenter < BasePresenter
  presents :comment
  
  
  def title_and_link(group=1)
    if group == 1
      link_to( comment.commentable.title,  commentable_show_path(comment.commentable) ) +
      content_tag( :small ) do
        " (" + comment.commentable.class.to_s.humanize + ")"
      end
    else
      content_tag( :small, :style => 'font-size: 0.7em;' ) do
        I18n.translate(:orphanded_comment).html_safe
      end
    end
  end
  
  def avatar
    if user=comment.user
      image_tag( user.avatar_url(:thumb), :class => 'without-shadow', :style => 'float: right;')
    else
      image_tag( '/images/avatars/thumb/missing.png', :class => 'without-shadow', :style => 'float: right;')
    end
  end
    
  def user_and_time
    I18n.translate(:user_wrote_a_comment_at, :user => comment.name || 'Anonymous',
        :at => distance_of_time_in_words_to_now(comment.created_at)).html_safe
  end
  
  def user_time_and_ip
    user_and_time + 
    " (" +  comment.created_at + ", " +
    I18n.translate(:posted_from_ip, :ip => (comment.from_ip || "n/a") )
  end
  
  def render_comment(_concat=false)
    ContentItem::markdown(comment.comment||'').html_safe
  end
  alias_method :body, :render_comment

  
  def comment_class
    comment.created_at||Time::now > current_user_field(:last_sign_in_at,Time::now()-1.hour) ? "new_comment" : "old_comment"
  end
  
  def link_to_edit
    link_to( comment.time_left_to_edit > 0 ? \
       I18n.translate(:edit_for_another_count_minutes,:count => comment.time_left_to_edit) :\
       I18n.translate(:edit),
       edit_comment_path(comment, (comment.commentable.class.to_s.underscore.downcase+"_id").to_sym => comment.commentable.id.to_s ),
       :remote => true,
       :class => "button edit tiny" ) if can?( :manage, comment, session[:comments] )
  end  
  
  def link_to_destroy
    if can?( :destroy, session[:comments] ) 
      raw link_to( I18n.translate(:destroy),
            comment_path(comment, (comment.commentable.class.to_s.underscore.downcase+"_id").to_sym => comment.commentable.id.to_s ),
            :method => :delete,
            :remote => true,
            :confirm => t(:are_you_sure),
            :class =>  "button delete tiny"
           ).gsub("rel=\"nofollow\"","") 
    end
  end
end
