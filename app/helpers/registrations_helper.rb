# -*- encoding : utf-8 -*-

module RegistrationsHelper # :nodoc:

  def invited?
    if params[:token]
      resource.invitation = Invitation.where(token: params[:token]).first
      if resource.invitation
        resource.email = resource.invitation.email
        resource.name = resource.invitation.name
        session[:invitation_id] = resource.invitation_id
      end
    end
  end

end