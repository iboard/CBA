# Define methods which should be called with every request to your application
# or which should be callable from anywhere of your controllers
#
# == Preloading
# CBA will load all pages to <code>@top_pages</code> 
# marked with 'show_in_menu' and orders them by
# 'menu_order asc'. This pages will be displayed as a 'main-menu' 
# (see views/home/menu/)
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Load all pages marked with 'show_in_menu => true'
  before_filter  :load_top_pages

  # == Display a flash if CanCan doesn't allow access    
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  private
  def load_top_pages
    @top_pages ||= Page.where(:show_in_menu => true).asc(:menu_order)
  end
end
