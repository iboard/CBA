class UserNotificationsController < ApplicationController

  load_and_authorize_resource
  
  def new
    @user_notification = current_user.user_notifications.build()
  end
  
  def create
    if current_user.user_notifications.create(params[:user_notification])
      redirect_to root_path, notice: t(:message_successfully_sent)
    else
      render :new
    end
  end

end