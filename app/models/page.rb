class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title, :type => String
  validates_presence_of :title
  validates_uniqueness_of :title
  
  field :body, :type => String, :required => true
  validates_presence_of :body
  
  field :show_in_menu, :type => Boolean, :default => true
  field :menu_order, :type => Integer, :default => 99999
  
  has_attached_file :cover_picture,
                    :styles => { 
                      :medium => "300x500>",
                      :thumb  => "100x150>",
                      :icon   => "64x90"
                    }

  def render_body
    RedCloth.new(body).to_html
  end
  
  def render_intro
    RedCloth.new(body.paragraphs[0]).to_html
  end
end
