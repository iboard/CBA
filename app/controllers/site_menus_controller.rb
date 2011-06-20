class SiteMenusController < ApplicationController

  load_and_authorize_resource :except => [:index]

  def index
    authorize! :read, SiteMenu
    @site_menus = SiteMenu.roots
  end

  def new
    if params[:parent]
      parent = SiteMenu.find(params[:parent])
      @site_menu = parent.children.build()
    end
  end

  def create
    @site_menu = SiteMenu.create(params[:site_menu])
    if @site_menu.save
      redirect_to site_menus_path, :notice => t(:site_menu_successfully_created)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @site_menu.update_attributes(params[:site_menu])
      redirect_to site_menus_path, :notice => t(:site_menu_successfully_updated)
    else
      flash[:alert] = t(:site_menu_could_not_be_updated)
      render :edit
    end
  end

  def destroy
    @site_menu.delete
    redirect_to site_menus_path, :notice => t(:site_menu_deleted)
  end
  
  def sort_menus
    params[:site_menu].each_with_index do |id,idx|
      m = SiteMenu.find(id)
      m.position = idx
      m.save
    end
    render :nothing => true
  end

end
