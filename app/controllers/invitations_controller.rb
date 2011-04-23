class InvitationsController < ApplicationController

  load_and_authorize_resource :invitation
  load_and_authorize_resource :user  
  
  def new
    @invitation = @user.invitations.build()
  end
  
  def create
    @invitation = current_user.invitations.create(params[:invitation])
    if @invitation.save
      redirect_to profile_path(current_user), 
        :notice => t(:invitation_sent, :email => @invitation.email, :name => @invitation.name)
    else
      render :new
    end
  end

end