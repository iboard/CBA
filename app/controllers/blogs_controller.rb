# -*- encoding : utf-8 -*-

class BlogsController < ApplicationController

  load_and_authorize_resource
  before_filter :ensure_page_tokens, :only => [:update,:create]

  def index
    @blogs = Blog.all.paginate(
       :page => params[:page],
       :per_page => APPLICATION_CONFIG[:pages_per_page] || 5
     )

     respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @blogs }
     end
  end

  # Show all postings for this blog
  def show
    @postings = @blog.postings.desc(:created_at)\
      .paginate(:page => params[:page],:per_page => CONSTANTS['paginate_postings_per_page'].to_i)
    respond_to do |format|
      format.js {
         @path = blog_path(@blog, :page => (params[:page] ? (params[:page].to_i+1) : 2) )
      }
      format.html # index.html.erb
      format.xml  { render :xml => @blog }
    end
  end


  def new
  end

  def create
    @blog = Blog.new(params[:blog])
    if @blog.save
      redirect_to @blog, :notice => t(:blog_successfully_created)
    else
      render :new
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        format.html {
           redirect_to(@blog, :notice => t(:blog_successfully_updated))
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/:id
  # DELETE /blogs/:id.xml
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to(blogs_url, :notice => t(:blog_successfully_destroyed)) }
      format.xml  { head :ok }
    end
  end

  # GET /blogs/:id/delete_cover_picture
  def delete_cover_picture
    @blog.cover_picture.destroy
    @blog.save
  end

  private
  def ensure_page_tokens
    params[:blog][:page_tokens] ||= []
  end

end
