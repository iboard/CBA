class ApplicationController < ActionController::Base
  protect_from_forgery


  # Display a flash if CanCan doesn't allow access    
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

end
