class PostingPresenter < BasePresenter
  presents :posting
  
  def edit_buttons(_concat=true)
    _rc = content_tag( :div, :class => 'side-tab', :id => "side-tab-posting_#{posting.id.to_s}" ) do
      content_tag( :div, :class => 'comment-links', :id => "posting_#{posting.id.to_s}", 
                        :onmouseover=> "cancelSideTabTimeouts()", 
                        :onmouseout => "hideWithDelay('posting_#{posting.id.to_s}',500)") do
        content_tag(:span, :class=>"item_link_buttons", 
                           :style=>"display: inline", 
                           :onmouseover=>"cancelSideTabTimeouts()") do
          [
            ui_button('read', "", blog_posting_path(posting.blog,posting), :id => "read-link"),
            (can?(:edit, posting) ? ui_button( 'edit', "", edit_blog_posting_path(posting.blog,posting),:id=>'edit-link') : nil),
            (can?(:manage, posting) ? ui_button( 'destroy', "", blog_posting_path(posting.blog,posting), :confirm => I18n.translate(:are_you_sure), :method => :delete, :id =>'destroy-link') : nil)
          ].compact.join(sc(:nbsp)).html_safe
        end
      end
    end
    concat_or_string(_concat,_rc)
  end
  
  def cover_picture(style='',format=:medium,_concat=true)
    concat_or_string _concat, render( :partial => 'postings/cover_picture.html.erb', :locals => { :posting => posting, :style => style, :format => format })
  end
  
  def title(_concat=true)
    concat_or_string(_concat,content_tag( :h1, :onmouseover=> "showSideTab($('#posting_#{posting.id.to_s}'));", 
                     :onmouseout=>"hideWithDelay('posting_#{posting.id.to_s}',2000);") do
      link_to(posting.title, blog_posting_path(posting.blog,posting))
    end)
  end
  
  def title_and_blog(_concat=true)
    concat_or_string(_concat,content_tag( :h1, :onmouseover=> "showSideTab($('#posting_#{posting.id.to_s}'));", 
                     :onmouseout=>"hideWithDelay('posting_#{posting.id.to_s}',2000);") do
      link_to(posting.title, blog_posting_path(posting.blog,posting))+
      content_tag( :span, style: "font-size: smaller" ) do
        link_to( I18n.translate(:in_blog, blog: posting.blog.title), posting.blog)
      end
    end)
  end
  
  def body(_concat=true)
    _rc = if interpreter
      interpreter.render(posting.body)
    else
      posting.body
    end
    concat_or_string(_concat, _rc)
  end
  
  def intro(_concat=true)
    _rc = if interpreter
      interpreter.render(posting.intro)
    else
      posting.intro(false)
    end
    concat_or_string(_concat,_rc)
  end
  
  def user_and_time(_concat=true)
    _output = 
    content_tag( :address, :class => "#{posting.created_at > current_user_field( :last_sign_in_at,Time::now()-1.hour) ? 'new_posting' : 'old_posting'}") do
      _rc = I18n.translate(:user_wrote_a_comment_at, :user => posting.user.name, 
                           :at => distance_of_time_in_words_to_now(posting.created_at)).html_safe
      if block_given?
        _rc += yield
      end
      _rc
    end
    concat_or_string(_concat, _output)    
  end
  
  def user_time_and_blog(_concat=true)
    _rc = user_and_time do 
      link_to( I18n.translate(:in_blog, blog: posting.blog.title), posting.blog)
    end
    concat_or_string(_concat,_rc)
  end

  def comment_links(_concat=true)
    _rc = if postings_visible?
      content_tag( :p, :class => 'posting_comment_links') do
        content_tag( :span, :class=> 'comments_counter') do
          rc = I18n.translate(:num_of_comments, :count => posting.comments.count)
          if (user_signed_in? && ((count=posting.comments.since(current_user.last_sign_in_at).count) > 0))
            rc += " (" + content_tag( :span, :class=>'new_comments' ) {
              I18n.translate(:new_since_last_visit, :count => count)
            }+")"
          end
          (rc += "<br/>").html_safe
        end
      end
    end
    concat_or_string(_concat,_rc)
  end
  
  def comments(_concat=true)
    concat_or_string(_concat,
      render( :partial => 'comments', :locals => {:posting => posting, :interpreter => interpreter} )
    )
  end
  
  def tags(_concat=true)
    _rc = content_tag( :div, :class => 'tags') do
      posting.tags_array.map { |tag|
        link_to( tag, tags_path(tag)) unless tag.blank?
      }.compact.join(", ").html_safe
    end
    concat_or_string(_concat,_rc)
  end
  
  def tags_and_limited_information(_concat=true)
    _rc = content_tag( :div, :class => 'tags') do
      txt = posting.tags_array.map { |tag|
        link_to( tag, tags_path(tag)) unless tag.blank?
      }.compact.join(", ").html_safe
      unless posting.public?
        txt += I18n.translate(:limited_posting)
      end
      txt.html_safe
    end
    concat_or_string(_concat,_rc)
  end
  
  def read_more(_concat=true)
    _rc = if posting.body.paragraphs.count > 1
      ui_button 'read', I18n.translate(:read_more), posting
    end
    concat_or_string(_concat,_rc)
  end
  
private
  def postings_visible?
    posting.blog.allow_public_comments || (posting.blog.allow_comments && user_signed_in?) || posting.comments.any?
  end

end