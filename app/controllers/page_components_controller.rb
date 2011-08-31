class PageComponentsController < ApplicationController

  before_filter :load_page_and_page_component

  def edit
  end

  def update
    _updated = @page_component.update_attributes(params[:page_component])
    respond_to do |format|
      format.html {
        if _updated
          redirect_to @page, :notice => t(:page_component_successfully_updated)
        else
          render :edit
        end
      }
      format.js {
      }
    end
  end
 
  private
  def load_page_and_page_component
    @page = Page.find(params[:page_id])
    @page_component = @page.page_components.find(params[:id])
  end

end
