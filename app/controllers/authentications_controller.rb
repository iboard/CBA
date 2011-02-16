# AuthenticationController will handle OmniAuth-providers for an existing
# user. Since authentications are handled by the omni-gem all we need is
# index, create, and delete. There is no need to edit/update or show a single
# authentication.
class AuthenticationsController < ApplicationController
  
  # Load user's authentications (Twitter, Facebook, ....)
  def index
    @authentications = current_user.authentications if current_user
  end
  
  # Create an authentication when this callback is called from
  # the authentication provider
  def create
    omniauth = request.env["omniauth.auth"]  
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    if authentication  
      flash[:notice] = t(:signed_in_successfully)
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      # Add authentication to signed in user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = t(:authentication_successful)
      redirect_to authentications_url
    elsif user = create_new_omniauth_user(omniauth)
      # Create a new User through omniauth
      flash[:notice] = t(:signed_in_successfully)
      sign_in_and_redirect(:user, user)
    else
      # New user data not valid, try again
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_user_registration_url
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = t(:successfully_destroyed_authentication)
    redirect_to authentications_url
  end
  
  def auth_failure
    redirect_to '/users/sign_in', :alert => params[:message]
  end
  
  private
  def create_authentication(omniauth)
    Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
  end
  
  def create_new_omniauth_user(omniauth)
    user = User.new
    user.apply_omniauth(omniauth)
    if user.save
      user
    else
      nil
    end
  end
end
