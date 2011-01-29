class BlogsController < ApplicationController
  
  load_and_authorize_resource
  
  def index
    @blogs = Blog.paginate(
       :page => params[:page], 
       :per_page => APPLICATION_CONFIG[:pages_per_page] || 5
     )
    
     respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @blogs }
     end
  end
  
  def show
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
  
  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_cover_picture
    @blog.cover_picture.destroy
    @blog.save
  end

end
