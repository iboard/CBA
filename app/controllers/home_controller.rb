class HomeController < ApplicationController

  # Display the top pages on the home-page
  def index
    @blog = Blog.where(:title => t(:news)).first
  end

end
