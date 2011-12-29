# -*- encoding : utf-8 -*-

class BlogsController < ApplicationController

  before_filter :ensure_page_tokens, :only => [:update,:create]

  def index
    @blogs = scoped_blogs.all.paginate(
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
    @blog = scoped_find(params[:id])
    unless current_user
      _postings = @blog.scoped_postings.online.public.any_in(:is_draft=>[false, nil]).desc(:created_at)
    else
      unless draft_mode
        _postings = @blog.scoped_postings.online.any_in(:is_draft=>[false, nil]).addressed_to(current_user.id).desc(:created_at)
      else
        _postings = @blog.scoped_postings.online.where(:is_draft=>true).addressed_to(current_user.id).desc(:created_at)
      end
    end
    @postings = _postings.paginate(:page => params[:page],:per_page => CONSTANTS['paginate_postings_per_page'].to_i)
    respond_to do |format|
      format.js {
         @path = blog_path(@blog, :page => (params[:page] ? (params[:page].to_i+1) : 2) )
      }
      format.html # index.html.erb
      format.xml  { render :xml => @blog }
    end
  end


  def new
    @blog = Blog.new
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
    @blog = scoped_find(params[:id])
  end

  def update
    @blog = scoped_find(params[:id])
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
    @blog = scoped_find(params[:id])
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to(blogs_url, :notice => t(:blog_successfully_destroyed)) }
      format.xml  { head :ok }
    end
  end

  # GET /blogs/:id/delete_cover_picture
  def delete_cover_picture
    @blog = scoped_find(params[:id])
    @blog.cover_picture.destroy
    @blog.save
  end

  private
  # page_tokens are provided by checkboxes of the form. Make sure the
  # Array is initialized even if no checkbox is checked.
  def ensure_page_tokens
    params[:blog][:page_tokens] ||= []
  end

  # do a scoped find and raise an Error404 if document not found in scope
  def scoped_find(id)
    begin
      scoped_blogs.find(id)
    rescue
      raise Error404
    end
  end

  # For update and destroy we want to include drafts, so change the default_scope
  def scoped_blogs
    if current_role?(:author)
      Blog.for_role(current_role)
    else
      Blog.published.for_role(current_role)
    end
  end

end
