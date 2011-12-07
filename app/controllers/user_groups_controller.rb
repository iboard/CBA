class UserGroupsController < ApplicationController
  
  load_and_authorize_resource :user, :user_group
  before_filter :cancel_if_cancel_clicked, only: [:create,:update]
  
  def index
  end
  
  def new
    @user_group = @user.user_groups.build
  end
  
  def create
    @user_group = @user.user_groups.create(params[:user_group])
    if @user_group.valid?
      @user.save
      redirect_to user_user_groups_path(@user), notice: t(:user_group_successfully_created)
    else
      render :new
    end
  end
  
  def edit
    @user_group = @user.user_groups.find(params[:id])
  end
  
  def update
    @user_group = @user.user_groups.find(params[:id])
    @user_group.update_attributes(params[:user_group])
    if @user_group.valid?
      @user.save
      redirect_to user_user_groups_path(@user), notice: t(:user_group_successfully_updated)
    else
      render :new
    end
  end
  
  def destroy
    @user_group = @user.user_groups.find(params[:id])
    @user_group.delete
    @user.save
    redirect_to  user_user_groups_path(@user), notice: t(:user_group_successfully_deleted)
  end
  
private
  def cancel_if_cancel_clicked
    if params[:commit].present? && params[:commit].downcase == t(:cancel).downcase
      redirect_to user_user_groups_path(@user), :notice => t(:canceled)
    end 
  end
end