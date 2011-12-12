class PagePresenter < BasePresenter
  
  presents :page
  
  def cover_picture(style='',format=:medium,_concat=true)
    if !page.new_record? && page.cover_picture_exists?
      _rc = content_tag :div, class: 'cover_picture', id: 'cover_picture_'+page.id.to_s, style:  style do
        link_to_function( 
          image_tag( w3c_url(page.cover_picture.url(format) ),class: "img-with-shadow"),
          "image_popup('#{w3c_url(page.cover_picture.url(:popup))}')"
        )
      end
      concat_or_string(_concat,_rc)
    end
  end
  
  def body(_concat=true)
    _txt = self.interpreter.render( page.t(I18n.locale,:body) )
    concat_or_string(_concat,_txt)
  end
  
  def intro(_concat=true)
    _txt = self.interpreter.render( page.intro )
    concat_or_string(_concat,_txt)
  end
  
  def buttons(_concat=true)
    _txt = render :partial => 'pages/buttons', :locals => {:page => page, :interpreter => interpreter}
    concat_or_string(_concat,_txt)
  end
  
  def components(_concat=true)
    _rc = ""
    page.page_components.asc(:position).each do |page_component|
      interpret page_component do |component_presenter|
        _rc += concat_or_string(_concat,component_presenter.render_page_component)
      end
    end
    _rc
  end
  
  def attachments(_concat=true)
    _rc = render :partial => 'attachments', :locals => {:page => page, :interpreter => interpreter}
    concat_or_string(_concat,_rc)
  end
  
  def comments(_concat=true)
    _rc = render( :partial => 'comments', :locals => {:page => page, :interpreter => interpreter} )
    concat_or_string(_concat,_rc)
  end
  
  def render_with_template
    concat @interpreter.render(page.page_template.html_template)
    ""
  end
  
private
  def concat_or_string(_concat,_txt)
    if _concat
      concat _txt
      ""
    else
      _txt
    end
  end
    
end
