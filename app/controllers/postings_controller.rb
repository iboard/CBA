# -*- encoding : utf-8 -*-

class PostingsController < ApplicationController

  before_filter :unscope_drafts_for_authors
  before_filter :set_blog_id_if_missing
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
    if (@posting=@blog.create_posting(params[:posting],current_user)).errors.empty?
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

  private
  def set_blog_id_if_missing
    unless params[:blog_id]
      @posting = Posting.find(params[:id])
      @blog    = @posting.blog
    end
  end
  
  # For update and destroy we want to include drafts, so change the default_scope
  def unscope_drafts_for_authors
    if current_role?(:author) && session[:draft_mode] && session[:draft_mode] == true
      Posting.default_scope()
    end
  end
  
end
