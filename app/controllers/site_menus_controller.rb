# -*- encoding : utf-8 -*-

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
    if params[:site_menu].present?
      update_site_menu_position(params[:site_menu],SiteMenu.roots)
    else
      params.each do |key, values|
        id = key.gsub(/site_menu_children_of_/,"")
        update_site_menu_position(values,SiteMenu.find(id).children)
        break
      end
    end
    render :nothing => true
  end
  
  private
  def update_site_menu_position(sort_params,branch)
    sort_params.each_with_index do |id,idx|
      m = branch.detect {|b| b.id.to_s == id}
      m.position = idx
      m.save
    end
  end

end
