class SearchController < ApplicationController

  def index
    @search_model=Search.new(params[:search])
    if @search_model.valid?
      @search = @search_model.result.reject{ |r|
        r[0].is_a?(Array) || cannot?(:read, r[0] )
      }
    else
      flash.now[:alert] = t(:invalid_search)
    end
    @search ||= []
    respond_to do |format|
      format.html
      format.js
    end
  end

end
