# -*- encoding : utf-8 -*-

class RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil unless resource.new_record?
  end

  def update
    if password_needed?
      set_flash_message :notice, :updated
      sign_in resource_name, resource
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      resource.apply_omniauth(session[:omniauth])
      resource.valid?
    end
  end

  def after_update_path_for(resource)
    crop_avatar_user_path(:id => resource.id.to_s)
  end

  # Users, signed up with 'standard user/password' must repeat their
  # password, when changing their account, but users,
  # authenticated through an omniAuth-provider, doesn't.
  def password_needed?
    resource.authentications.empty? \
     ? resource.update_with_password(params[resource_name])\
     : resource.update_attributes(params[resource_name])
  end
end