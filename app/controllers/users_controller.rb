class UsersController < ApplicationController
  
  load_and_authorize_resource
  #before_filter :authenticate_user!
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def crop_avatar
    @user = User.find(params[:id])
    unless @user.new_avatar?
      redirect_to @user 
      return
    end
    if params[:user] && 
       params[:user][:crop_x] && params[:user][:crop_y] && 
       params[:user][:crop_w] && params[:user][:crop_h]
      if @user.update_attributes(params[:user]) 
        render :show
      else
        redirect_to edit_user_path(@user), :error => @user.errors.map(&:to_s).join("<br/>")
      end
    end
  end
  
  def edit_roles
    @user = User.find(params[:id])
  end
  
  def update_roles
    @user = User.find(params[:id])
    @user.update_attributes!(params[:user])
    redirect_to registrations_path, :notice => t(:roles_of_user_updated,:user => @user.name)
  end


end
