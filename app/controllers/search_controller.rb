class SearchController < ApplicationController

  def index
    @search ||= Search.new(params[:search])
    flash.now[:alert] = t(:invalid_search) unless @search.valid?
    respond_to do |format|
      format.html
      format.js
    end
  end

end
