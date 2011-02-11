class UsersController < ApplicationController
  
  load_and_authorize_resource
  respond_to :html, :js

  def index
    @users = User.all.reject {|u|
      !can? :read, u
    }.paginate( :page => params[:page], 
                :per_page => CONSTANTS['paginate_users_per_page'])

    respond_to do |format|
       format.js { render :index }
       format.html { render :index }
    end
  end

  def show
  end
  
  def edit_role
  end
  
  def update_role
    @user.update_attributes!(params[:user])
    redirect_to registrations_path, :notice => t(:role_of_user_updated,:user => @user.name)
  end

  def crop_avatar
    if !@user.new_avatar?
      redirect_to @user, :notice => flash[:notice] 
    elsif is_in_crop_mode?
      if @user.update_attributes(params[:user]) 
        render :show
      else
        redirect_to edit_user_path(@user), :error => @user.errors.map(&:to_s).join("<br />")
      end
    end
  end
  
  def destroy
    @user.delete
    redirect_to registrations_path,
      :notice => t(:user_deleted)
  end

  private
  def is_in_crop_mode?
    params[:user] && 
    params[:user][:crop_x] && params[:user][:crop_y] && 
    params[:user][:crop_w] && params[:user][:crop_h]
  end
end
