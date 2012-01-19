# -*- encoding : utf-8 -*-

# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
# The original LayoutHelper module was done by Ryan Bates and got some
# extensions for our project.
module LayoutHelper

  # Set the title of the html-page.
  # ==parameters: 
  #   show_title::
  #     If true the title will also displayed as a h1-title within the
  #     html-page not only in the browser-window-title
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.html_safe) }
    @show_title = show_title
  end

  # Let's see if there is a title for the h1-title
  def show_title?
    @show_title
  end

  # Put stylesheets in the yield used in application.html.erb
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  # Put javascripts to the html-head
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  # Outputs a Javascript to place the title of a page at the URL in cases
  # where the page was addressed by it's ID
  # ==parameters:
  #   page:
  #     The `Page` to set address for
  #   title:
  #     HTML-Title to use
  def set_browser_address(page,title)
    unless title.length > CONSTANTS['title_max_length'].to_i
      address = "/p/"+title.txt_to_url
      "<script>
         history.replaceState( {page: '#{page}'},'#{title}', '#{address}');
       </script>".html_safe
     end
  end

  # Replace blanks by %20 to satisfy w3c-validators
  # Attantion: This is implemented in BasePresenter too!
  def w3c_url(url)
    url.gsub(' ', '%20')
  end
  
  # Links as buttons
  def link_button( label_txt, button_options, *args )
    link_to label_txt, *args, :class => button_options
  end
  
  # render a pagination box if resource has items
  # @param [Array] paginations the slected Items to display
  def render_pagination_box paginations
    if paginations.total_pages > 1
      haml_tag(".pagination_box") do
        concat(will_paginate(paginations))
      end
    end
  end

  def current_tag_cache_key
    key = "tag_cloud_" + (current_user ? current_user.id.to_s : 'public')
  end
  
  # render a tag-cloud
  def tag_cloud
    ContentItem::normalized_tags_with_weight(Posting).map { |tag,weight|
      unless tag.blank?
        if accessible_postings(tag,current_role).any?
          content_tag :span, :class => "tag-weight-#{weight.to_s.gsub('.','-')}" do
            link_to( "#{tag}", tags_path(tag))
          end
        end
      end
    }.compact.join(" ").html_safe
  end
  
  # render jquery-ui-buttons
  def ui_button(icon,label_text,url,options={})
    setup_button(icon,label_text,options)
    link_to( icon_and_text(label_text,icon), url, options ).html_safe
  end

  # render button for link_to_function
  def ui_link_to_function(icon,label_text,function_call,options={})
    setup_button(icon,label_text,options)
    link_to_function(icon_and_text(label_text,icon),function_call,options).html_safe
  end

  def accessible_postings(tag,role)
    _ids = Blog.for_role(role).only(:id).map{ |blog|
      blog.postings_for_user_and_mode(current_user,draft_mode).only(:id).map(&:_id)
    }.flatten
    Posting.any_in(_id: _ids).tagged_with(tag)
  end


private

  def setup_button(icon,label_text,options)
    class_names = 'ui-button ui-widget ui-state-default ui-corner-all'
    if options[:add_class]
      class_names += " " + options[:add_class]
      options.delete(:add_class)
    end
    style = 'padding: 5px; padding-top: 2px; padding-bottom: 3px; text-align: left;'           
    if options[:add_style]
      style += " " + options[:add_style]
      options.delete(:add_style)
    end     
    options.merge!( class:  class_names, style:  style)
    options.merge!( title: I18n.translate(icon.to_sym)) if label_text.blank?
  end

  def icon_and_text(text, icon)
    rc = ""
    rc = icon ? content_tag( :span, 
                 :style => 'display: inline-block; width: 16px; height: 16px;', 
                 :class => "ui-icon ui-icon-#{map_icon(icon)}") {} : ''
    rc +=  content_tag(:span, :class => 'button-label') { text }
    rc.html_safe
  end

  def map_icon(shortcut)
    case shortcut
    when 'read', 'read-link'
      'newwin'
    when 'edit'
      'pencil'
    when 'destroy', 'delete'
      'trash'
    when 'add', 'plus'
      'plusthick'
    when 'back'
      'circle-arrow-w'
    when 'mark-read'
      'mail-open'
    when 'mark-unread', 'mail', 'email'
      'mail-closed'
    when 'details', 'zoom'
      'zoomin'
    when 'sort'
      'arrowthick-2-n-s'
    when 'table'
      'calculator'
    when 'pdf'
      'document'
    when 'video'
      'video'
    when 'expand'
      'folder-open'
    when 'collapse'
      'folder-collapsed'
    when 'attachment'
      'bookmark'
    when 'todo'
      'signal-diag'
    when 'question'
      'help'
    when 'assets'
      'suitcase'
    when 'contact', 'people', 'vcard', 'groups'
      'contact'
    else
      shortcut
    end
  end

end
