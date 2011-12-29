# -*- encoding : utf-8 -*-

class PagesController < ApplicationController

  respond_to :html, :xml, :js

  before_filter :set_default_flags, :only => [:create, :update]
  before_filter :set_template_scope, :except => [:sort_components]
  
  # seems to use unscoped find ?!
  #   load_and_authorize_resource :except => [:permalinked,:new_article,:create_new_article]

  # GET /pages
  # GET /pages.xml
  def index
    @pages = scoped_pages.order([:menu_order,:asc],[:created_at, :desc]).all.paginate(
      :page => params[:page],
      :per_page => APPLICATION_CONFIG[:pages_per_page] || 5
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    begin
      if current_role?(:maintainer)
        @page = Page.unscoped.find(params[:id])
      else
        @page = scoped_pages.find(params[:id])
      end
    rescue
      redirect_to pages_path, :alert => t(:document_not_found)
      return
    end
    authorize! :show, @page
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

  # GET /p/titel_of_the_page
  def permalinked
    permalink = params[:permalink].url_to_txt.escape_regex
    unless params[:permalink][-1] == '$'
      @page = scoped_pages.where(:title => /^#{permalink}$/i).first
    else
      @page = scoped_pages.where(:title => /^#{permalink.chomp('\$')}(.*)$/i).first
    end
    render :show if @page
    unless @page
      redirect_to pages_path, :alert =>  t(:page_not_found) + " (#{permalink})"
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    authorize! :create, @page
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end


  # GET /pages/new_article
  # Presents a list of page-templates.
  # The submit-button will lead to :post /pages/create_new_article
  def new_article
    authorize! :create, Page
    @templates = Page.templates
  end

  # GET /pages/1/edit
  def edit
    # Workarround for :fields_for which will ignore default_scope of components
    if current_role?(:maintainer)
      @page = Page.unscoped.find(params[:id])
    else
      @page = scoped_pages.find(params[:id])
    end
    authorize! :edit, @page
    @page.page_components.sort! {|a,b| a.position <=> b.position }
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
    authorize! :create, Page
    
    respond_to do |format|
      if @page.save
        format.html { redirect_to(@page, :notice => t(:page_successfully_created)) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /pages/create_new_article
  def create_new_article
    authorize! :create, Page
    @template = Page.templates.find(params[:page][:template_id])
    @page = Page.new(@template.attributes)
    @page.is_template = false
    @page.template_id=@template.id
    @page.page_components = []
    @template.page_components.each do |component|
      @page.page_components.build( component.attributes )
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    if current_role?(:maintainer)
      @page = Page.unscoped.find(params[:id])
    else
      @page = Page.find(params[:id])
    end
    authorize! :update, @page
    respond_to do |format|
      if @page.update_attributes(params[:page])
        @page.attachments.each { |att| att.save }
        if @page.is_draft && draft_mode == false
          change_draft_mode(true) 
          notice = t(:page_successfully_updated_and_switched_to_draft_mode)
        else
          notice = t(:page_successfully_updated)
        end
        format.html {
           redirect_to(@page, :notice => notice)
        }
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
    authorize! :destroy, @page
    @page.destroy
    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end

  # GET /pages/:id/delete_cover_picture
  def delete_cover_picture
    @page = Page.find(params[:id])
    authorize! :edit, @page
    @page.cover_picture.destroy
    @page.save
    respond_to do |format|
      format.html { render :nothing => true }
      format.js
    end
  end

  # GET /pages/templates
  def templates
    @pages = Page.templates
  end

  # GET /pages/sort_components
  # POST /pages/sort_components
  def sort_components
    @page = Page.find(params[:id])
    unless params[:component]
      respond_to do |format|
        format.html
        format.js
      end
    else
      params[:component].each_with_index do |component,idx|
        c = @page.page_components.find(component)
        c.position = (idx+1)*10
      end
      @page.save
      render :nothing => true
    end
  end

  private
  def set_template_scope
    if params[:id] && current_role?(:admin)
      @page = Page.unscoped.find(params[:id])
      Page.default_scope( :where => { :is_template => true } ) if @page.is_template
    end
  end
  
  
  # For update and destroy we want to include drafts, so change the default_scope
  def scoped_pages
    if current_role?(:author) && draft_mode
      Page
    else
      Page.published
    end
  end

  # Make sure flags draft and template are switched off if checkbox isn't checked
  def set_default_flags
    params[:is_draft]    ||= "0"
    params[:is_template] ||= "0"
  end  
  
end
