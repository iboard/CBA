class UserNotificationsController < ApplicationController

  load_and_authorize_resource  except: [:destroy]
  
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
  
  def destroy
    @user = User.find(params[:user_id])
    @user_notification = @user.user_notifications.find(params[:id])
    authorize! :manage, @user_notification
    @user_notification.delete
    @user.save
    redirect_to notifications_path, notice: t(:notification_successfully_deleted)
  end
  
  def emails
    respond_to do |format|
       format.json { 
         render :json => User.any_of({ name: /#{params[:q]}/i }, { email: /#{params[:q]}/i })
                             .only(:email,:name)
                             .map{ |user| 
                               [
                                 :id =>user.email, 
                                 :name => user.name + " (#{user.email})"
                               ]
                              }
                             .flatten
       }
     end
  end

end