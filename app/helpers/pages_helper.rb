module PagesHelper
  
  def setup_action_buttons
    content_for :action_buttons do
      link_to( t(:new_page), new_page_path ) if can? :manage, Page
    end
  end
  
end
