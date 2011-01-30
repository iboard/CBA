class PostingsController < ApplicationController

  load_and_authorize_resource :blog
  load_and_authorize_resource :posting
  
  def index
  end
  
  def show
  end
  
  def new
    @posting = @blog.postings.build(:user => current_user)
  end
  
  def create
    @posting = @blog.postings.create(params[:posting])
    @posting.user = current_user
    if @posting.save && @blog.save
      redirect_to @blog, :notice => t(:posting_successfully_created)
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @posting.update_attributes(params[:posting])
      redirect_to @blog, :notice => t(:posting_successfully_updated)
    else
      render :edit
    end
  end
  
  def destroy
    @posting.destroy
    redirect_to @blog, :notice => t(:posting_successfully_destroyed)
  end

  def delete_cover_picture
    @posting.cover_picture.destroy
    @posting.save
  end
  
end
