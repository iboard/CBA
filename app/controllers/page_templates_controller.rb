# -*- encoding : utf-8 -*-

class PageTemplatesController < ApplicationController

  load_and_authorize_resource

  def index
  end

  # Show all postings for this blog
  def show
  end


  def new
  end

  def create
    @page_template = PageTemplate.new(params[:page_template])
    if @page_template.save
      redirect_to page_templates_path, :notice => t(:page_template_successfully_created)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page_template.update_attributes(params[:page_template])
      redirect_to(page_templates_path, :notice => t(:page_template_successfully_updated))
    else
      render :edit
    end
  end

  def destroy
    if @page_template.delete
      redirect_to(page_templates_path, :notice => t(:page_template_successfully_destroyed))
    else
      redirect_to(page_templates_path, :alert => @page_template.errors[:base].first.to_s)
    end
  end

end
