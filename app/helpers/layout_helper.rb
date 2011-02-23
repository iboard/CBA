# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
# The original LayoutHelper module was done by Ryan Bates and got some
# extensions for our project.
module LayoutHelper
  
  # Set the title of the html-page.
  # :param: show_title
  #   If true the title will also displayed as a h1-title within the
  #   html-page not only in the browser-window-title
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
  
  # if the link is a link to the current-page display it with a different
  # css-class to inform the user about 'here you are'.
  def menu_link_to(name,path)
    style = current_page?(path) ? \
              "hmenu_current" : \
              "hmenu"
    link_to name, path, :class => style
  end
  
  # Outputs a Javascript to place the title of a page at the URL in cases 
  # where the page was addressed by it's ID
  def set_browser_address(page,title)
    unless title.length > CONSTANTS['title_max_length'].to_i
      address = "/p/"+title.txt_to_url
      "<script>
         history.replaceState( {page: '#{page}'},'#{title}', '#{address}');
       </script>".html_safe
     end
  end
  
  # Replace blanks by %20 to satisfy w3c-validators
  def w3c_url(url)
    url.gsub(' ', '%20')
  end
  
end
