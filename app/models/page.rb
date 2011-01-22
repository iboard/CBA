class Page < Blogables::Blogable
  
  store_in :pages # By deriving from Blogables::Blogable, MongoId would
                  # store in blogables_blogables without this line but
                  # we want the collection named pages.
  
  field :show_in_menu, :type => Boolean, :default => true
  field :menu_order, :type => Integer, :default => 99999
  
  scope :top_pages, :where => { :show_in_menu => true }, :asc => :menu_order
        
  has_attached_file :cover_picture,
                    :styles => { 
                      :medium => "300x500>",
                      :thumb  => "100x150>",
                      :icon   => "64x90"
                    }
                    
  embeds_many :comments
  validates_associated :comments
  
  def cover_picture_exists?
    cover_picture && !cover_picture.original_filename.blank?
  end
  
  def render_body
    RedCloth.new(body).to_html
  end
  
  def render_intro
    RedCloth.new(body.paragraphs[0]).to_html
  end

end
