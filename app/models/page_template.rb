class PageTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  field :name, :required => true, :default => 'default'
  validates_presence_of :name
  validates_uniqueness_of :name
  index :name, :unique => true
  field :html_template, :required => true, :default => '<h1>TITLE</h1>BUTTONS COVERPICTURE<br/>BODY<hr>COMPONENTS<hr>COMMENTS'
  field :css_class, :required => true, :default => 'default'

  def render(&block)
    "<div class='#{self.css_class}'>" +
      yield( self.html_template )     +
    "</div>"
  end

end
