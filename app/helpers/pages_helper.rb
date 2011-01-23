module PagesHelper
  
  # If in PagesController, display the admin-buttons in the action_buttons-
  # yield. See the main-layout application.html.erb where this buttons
  # will be displayed at runtime.
  def setup_action_buttons
    content_for :action_buttons do
      link_to( t(:new_page), new_page_path ) if can? :manage, Page
    end
  end
  
end
