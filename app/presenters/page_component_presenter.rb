class PageComponentPresenter < BasePresenter
  
  presents :page_component
  
  def render_page_component(embedded=true)
    if current_role?(:maintainer)
      _edit = content_tag :p, class: 'page-component-edit' do
        ui_button( 'edit', I18n.translate(:edit), edit_page_page_component_path(page_component.page,page_component), :remote => true)
      end
    else
      _edit = ""
    end
    content_tag :div, class: 'page-component', id: "page-component-"+ page_component.id.to_s do
      if page_component.page_template_id 
        _template = page_component.page_template.html_template 
        _css_class= page_component.page_template.css_class
      else
        _template = "<h1>TITLE</h1><div>BODY</div><p>BUTTONS</p>"
        _css_class= "default-page-component"
      end
      content_tag :div, class: _css_class do
        interpreter.render( _template,embedded ) + _edit
      end
    end
  end

  def title(_concat=false)
    concat_or_string _concat, interpreter.render( page_component.t(I18n.locale,:title), false)
  end
  
  def body(_concat=false)
    concat_or_string _concat, interpreter.render( page_component.t(I18n.locale,:body), false)
  end
  
  def buttons(_concat=false)
    return "" unless current_role?(:maintainer)
    
    _rc = content_tag :p, class: 'page-component-edit' do
       ui_button( 'edit', I18n.translate(:edit), edit_page_page_component_path(page_component.page,page_component), :remote => true)
    end
    
    concat_or_string _concat, _rc
  end
  
  def components(_concat=false)
    ""
  end
  
  def comments(_concat=false)
    ""
  end
  
  def attachments(_concat=false)
    ""
  end
  
end
