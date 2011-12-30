# -*- encoding : utf-8 -*-

class PostingsController < ApplicationController

  before_filter :set_blog_id_if_missing,     except: [:tags]
  load_and_authorize_resource :blog,         except: [:tags]
  load_and_authorize_resource :posting,      except: [:tags]

  def index
  end

  def tags
    respond_to do |format|
      format.json {
        render :json => Posting.tags.reject{|t| t !~ /#{params[:q]}/i}
                        .map{|tag| [:id =>tag, :name => tag]}.flatten
      }
    end
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
  
  def update
    if @posting.update_attributes(params[:posting])
      @posting.attachments.each do |att|
        att.save!
      end
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
      params[:blog_id] = @blog.to_param
    end
  end

end
