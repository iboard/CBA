# A Page is a blogabble semi-static content-item.
# If <code>show_in_menu</code> the page will have a link in the
# application menu.
# Pages can be addressed by <code>/pages/OBJECT_ID</code> or
# <code>/p/TITLE_OF_THE_PAGE</code>. It can have comments and a 'cover-picture'
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
  
  # check if a picture exists. If you call <code>paperclip_field.url(:mode)</code>
  # paperclip will return <code>.../missing.png</code> at least and this is
  # always true. Use <code>cover_picture_exists?</code> to check if there
  # is a real picture there.
  def cover_picture_exists?
    cover_picture && !cover_picture.original_filename.blank?
  end
  
  # Render the body with RedCloth
  def render_body
    RedCloth.new(body).to_html
  end
  
  # Render the intro (which is the first paragraph of the body)
  def render_intro
    RedCloth.new(body.paragraphs[0]).to_html
  end
  
  # A standard <code>link_to 'Name', @page</code> will put in a link
  # to "/pages/OPBJECT_ID" but we want to see the title in the link
  # (Google prefers that). See: PagesController::permalinked
  def link_to_title 
    short_title_for_url.txt_to_url
  end

end
