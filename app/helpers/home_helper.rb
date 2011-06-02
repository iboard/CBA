module HomeHelper # :nodoc:
  
  # Render a twitter-box of config/twitter.html exists
  def insert_twitter_box
    if File.exist?( filename=File.expand_path("../../../config/twitter.#{Rails.env}.html", __FILE__))
       File.new(filename).read.html_safe
    end
  end
  
  
end
