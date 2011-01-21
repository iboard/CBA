class PagesController < ApplicationController

  respond_to :html, :xml, :js
  
  load_and_authorize_resource :except => :permalinked
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.paginate(
      :page => params[:page], :per_page => APPLICATION_CONFIG[:pages_per_page] || 5
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    params[:comment] ||= { 
      :name => user_signed_in? ? current_user.name : t(:anonymous),
      :email=> user_signed_in? ? current_user.email : '',
      :comment => ""
    }
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end
  
  def permalinked
    permalink = params[:permalink].url_to_txt.escape_regex
    @page = Page.where(:title => /^#{permalink}$/i).first
    redirect_to @page if @page
    unless @page
      flash[:error] = t(:page_not_found) + " (#{permalink})"
      redirect_to pages_path
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to(@page, :notice => 'Page was successfully created.') }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to(@page, :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_cover_picture
    @page.cover_picture.destroy
    @page.save
  end
  
end
