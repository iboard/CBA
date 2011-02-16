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
  
  layout APPLICATION_CONFIG['layout'] ? APPLICATION_CONFIG['layout'].to_s.strip : 'application'
  before_filter  :set_language_from_cookie
  
  # == Display a flash if CanCan doesn't allow access    
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
  
  helper_method :top_pages
  helper_method :pivotal_tracker_project
  helper_method :github_project
  helper_method :twitter_name
  helper_method :twitter_link

  def is_current_user? usr
    return current_user && (current_user == usr)
  end

  private

  def top_pages
    @top_pages ||= Page.where(:show_in_menu => true).asc(:menu_order)
  end

  def pivotal_tracker_project
    @pivotal_tracker_project ||= APPLICATION_CONFIG['pivotal_tracker_project']
  end
  
  def github_project
    @github_project          ||= APPLICATION_CONFIG['github_project']
  end
  
  def twitter_name
    @twitter_name            ||= APPLICATION_CONFIG['twitter_name']
  end
  
  def twitter_link
    @twitter_link            ||= APPLICATION_CONFIG['twitter_link']
  end
  
  def set_language_from_cookie
    if cookies && cookies[:lang]
      I18n.locale = cookies[:lang].to_sym
    end
  end  
  
end
