class InvitationsController < ApplicationController

  load_and_authorize_resource :invitation
  load_and_authorize_resource :user  
  
  def new
  end
  
  def create
  end
  
  
end