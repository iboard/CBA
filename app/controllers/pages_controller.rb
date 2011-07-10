# -*- encoding : utf-8 -*-

class PagesController < ApplicationController

  respond_to :html, :xml, :js

  before_filter :set_template_scope
  before_filter :unscope_drafts_for_authors
  load_and_authorize_resource :except => [:permalinked,:new_article,:create_new_article]

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all.paginate(
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
      @page = Page.where(:title => /^#{permalink}$/i).first
    else
      @page = Page.where(:title => /^#{permalink.chomp('\$')}(.*)$/i).first
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
    @page.page_components.sort! {|a,b| a.position <=> b.position }
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
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
    @page.page_components = []
    @template.page_components.each do |component|
      @page.page_components.build( component.attributes )
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html {
           redirect_to(@page, :notice => t(:page_successfully_updated))
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
    @page.destroy
    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end

  # GET /pages/:id/delete_cover_picture
  def delete_cover_picture
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

  private
  def set_template_scope
    if params[:id] && current_role?(:admin)
      @page = Page.unscoped.find(params[:id])
      Page.default_scope( :where => { :is_template => true, :is_draft => (session[:draft_mode]||false) } ) if @page.is_template
    end
  end
  
  
  # For update and destroy we want to include drafts, so change the default_scope
  def unscope_drafts_for_authors
    if current_role?(:author) && session[:draft_mode] && session[:draft_mode] == true
      Page.default_scope()
    end
  end
  
end
