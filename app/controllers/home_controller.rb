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
       format.js { render :index }
       format.html { render :index }
    end
    
  end

end
