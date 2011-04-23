class HomeController < ApplicationController

  respond_to :html, :js

  # Display the top pages on the home-page
  def index
    @blog = Blog.where(:title => t(:news)).first
    if @blog
      @postings = @blog.postings.desc(:created_at).paginate(
        :page => params[:page],
        :per_page => CONSTANTS['paginate_postings_per_page'].to_i
      )
    end
    respond_to do |format|
       format.js {
         @path = blog_path(@blog, :page => (params[:page] ? (params[:page].to_i+1) : 2))
         render :index
       }
       format.html { render :index }
    end
  end

  # GET /switch_locale/:locale
  def set_locale
    I18n.locale=params[:locale].to_sym
    cookies.permanent[:lang] = params[:locale]
    redirect_to request.env['HTTP_REFERER'], :notice => t(:language_switched_to, :lang => t("locales.#{params[:locale]}")).html_safe
  end

end
