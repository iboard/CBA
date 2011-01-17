class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter  :load_top_pages

  # Display a flash if CanCan doesn't allow access    
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  private
  def load_top_pages
    @top_pages = Page.where(:show_in_menu => true).asc(:menu_order)
  end
end
