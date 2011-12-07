# -*- encoding : utf-8 -*-

# Define a standard Error404 class used to rescue from this error
class Error404 < StandardError; end


# Define methods which should be called with every request to your application
# or which should be callable from anywhere of your controllers
#
# == Preloading
#   CBA will load all pages to <code>@top_pages</code>
#   marked with 'show_in_menu' and orders them by
#   'menu_order asc'. This pages will be displayed as a 'main-menu'
#   (see views/home/menu/)
#
# == Helper Methods
#
# -- helper_method :top_pages
#    Will load @top_pages (Pages shown in menu)
# -- helper_method :root_menu
#    Will load @root_menu. SiteMenu.roots.first
# -- helper_method :draft_mode
#    Is controller used in draft-mode? (Show postings and pages flaged as draft)
# 
# == Setup content for buttons on top of page
#
# -- Configured in `applicaiton.yml`
# * helper_method :pivotal_tracker_project
# * helper_method :github_project
# * helper_method :twitter_name
# * helper_method :twitter_link

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Catch "Not-found"
  rescue_from Error404, :with => :render_404
  
  # Use a layout-file defined in application.yml
  layout APPLICATION_CONFIG['layout'] ? APPLICATION_CONFIG['layout'].to_s.strip : 'application'  

  # persistent language for this session/user
  before_filter  :set_language_from_cookie
  before_filter  :apply_invitation
  before_filter  :setup_search

  # == Display a flash if CanCan doesn't allow access
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    if Rails.env == 'test'
      debug_msg = exception.subject.attributes.map {|k,v| "K=#{k} V=#{v.inspect.upcase}"}.join(", ") 
      flash[:alert] += "(Action: #{exception.action.inspect}, Subject: #{exception.subject.class.to_s} #{debug_msg})"
    end
    redirect_to root_url
  end

  # Load what every controller may expect to be there
  helper_method :top_pages
  helper_method :root_menu
  helper_method :draft_mode

  # Setup content for buttons on top of page
  helper_method :pivotal_tracker_project
  helper_method :github_project
  helper_method :twitter_name
  helper_method :twitter_link
  helper_method :current_role?
  helper_method :current_role


  # @param [User] usr - Is this user the current_user?
  # @return Boolean true if current_user is usr
  def is_current_user? usr
    return current_user && (current_user == usr)
  end
  alias current_user? is_current_user?

private

  # Top Pages are shown in the top-menu
  # @return Criteria to all pages where :show_in_menu is true
  def top_pages
    @top_pages ||= Page.where(:show_in_menu => true).asc(:menu_order)
  end

  # @return [SiteMenu] first root-item of collection SiteMenu
  def root_menu
    @root_menu ||= SiteMenu.roots.first
  end

  # Load link to pivotal tracker from config
  # @return String - The URL of the pivotal-tracker-project of this website
  def pivotal_tracker_project
    @pivotal_tracker_project ||= APPLICATION_CONFIG['pivotal_tracker_project']
  end

  # Load link to github project from config
  # @return String - The URL of thegithub-project of this website
  def github_project
    @github_project          ||= APPLICATION_CONFIG['github_project']
  end

  # Load twitter nickname (button-label) from config
  # @return String - The NAME of the twitter-profile of this website
  def twitter_name
    @twitter_name            ||= APPLICATION_CONFIG['twitter_name']
  end

  # Load link to project's twitter-account from config
  # @return String - The URL of the twitter-profile of this website
  def twitter_link
    @twitter_link            ||= APPLICATION_CONFIG['twitter_link']
  end

  # Set a permanent coockie. User should stick to the same lang with each request.
  def set_language_from_cookie
    if cookies && cookies[:lang]
      I18n.locale = cookies[:lang].to_sym
    end
  end

  # Set user.confirmed and invitation.accepted_at if session has :invitation_id
  def apply_invitation
    if user_signed_in? && session[:invitation_id]
      invitation = Invitation.find(session[:invitation_id])
      current_user.roles_mask = invitation.roles_mask
      current_user.invitation = invitation
      current_user.confirmed_at = invitation.accepted_at = Time.now
      invitation.save!
      current_user.save!
      session[:invitation_id] = nil
      flash[:notice] = t(:thank_you_for_accepting_your_invitation)
    end
  end

  # @return Boolean - true if current_user's role is role or greater
  def current_role?(role)
    return false unless current_user
    User::ROLES.index(role.to_sym) <= current_user.roles_mask
  end
  
  # @return Integer - The role of the current_user 
  def current_role
    current_user ? (current_user.roles_mask||0) : 0
  end
    
  # @return Boolean true if user is in draft-mode (Postings and Pages marked as draft will be shown)
  def draft_mode
    return true if session[:draft_mode] && session[:draft_mode] == true
    false
  end
  
  # @param [Integer] mode - set a session-variable to mode if current_role is :author
  def change_draft_mode(mode)
    if current_role?(:author)
      session[:draft_mode] = (mode && mode == "1")
    else
      session[:draft_mode] = false
    end
  end
  
  # Make sure a search-param and @search is present
  def setup_search
    params[:search] ||= {:search => ""}
    @search ||= Search.new(params[:search]||{:search => ""})
  end
  
  # A helper to load presenters
  # @param [Object] object - The object to be presented
  # @param [Class] klass - If not using OBJECTPresenter as class-name
  def present(object, klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    klass.new(view_context, object)
  end
  
  # Render the 404-Template
  def render_404  
    respond_to do |format|  
      format.html { render :file => "#{Rails.root}/public/404.html", :status => '404 Not Found' }  
      format.xml  { render :nothing => true, :status => '404 Not Found' }  
    end  
    true  
  end

end
