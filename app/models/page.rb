# A Page is a blogabble semi-static content-item.
# If <code>show_in_menu</code> the page will have a link in the
# application menu.
# Pages can be addressed by <code>/pages/OBJECT_ID</code> or
# <code>/p/TITLE_OF_THE_PAGE</code>. It can have comments and a 'cover-picture'
class Page
  include ContentItem
  acts_as_content_item
  has_cover_picture

  field :show_in_menu, :type => Boolean, :default => true
  field :menu_order, :type => Integer, :default => 99999
  field :body, :type => String, :required => true
  validates_presence_of :body

  field :interpreter,                             :default => :markdown
  field :allow_comments,        :type => Boolean, :default => true
  field :allow_public_comments, :type => Boolean, :default => true

  scope :top_pages, :where => { :show_in_menu => true }, :asc => :menu_order

  references_many            :comments, :inverse_of => :commentable
  validates_associated       :comments

  # TODO: Move this definitions to a library-module
  # TODO: and replace this lines with just 'has_attchments'
  embeds_many :attachments
  validates_associated :attachments
  accepts_nested_attributes_for :attachments, :allow_destroy => true

  embeds_many :page_components
  accepts_nested_attributes_for :page_components, :allow_destroy => true

  field :page_template_id, :type => BSON::ObjectId
  def page_template
    PageTemplate.where(:_id => self.page_template_id.to_s).first if self.page_template_id
  end
  def page_template=(new_template)
    self.page_template_id = new_template.id if new_template
  end


  # Render the body with RedCloth or Discount
  def render_body(view_context=nil)
    @view_context = view_context unless view_context.nil?
    unless self.page_template_id && @view_context
      parts = [self.title, self.body]
      parts << self.page_components.asc(:position).map { |component|
        "\n" + component.title + "\n" + ("-"*component.title.length) + "\n" +
        (component.body || '')
      }
      render_for_html( parts.join("\n") )
    else
      render_with_template
    end
  end

  # Same as short_title but will append a $-sign instead of '...'
  # ... smells in URLs and one can not see the difference if ... is just
  # part of the title or comes from truncation.
  def short_title_for_url
    title.truncate(CONSTANTS['title_max_length'].to_i, :omission => '$' )
  end

  private
  # Render the intro (which is the first paragraph of the body)
  def content_for_intro
    render_for_html(body.paragraphs[0])
  end

  def render_with_template
    self.page_template.render do |template|
      template.gsub(/TITLE/, self.title)\
              .gsub(/BODY/,  self.render_for_html(self.body||''))\
              .gsub(/COMPONENTS/, render_components )\
              .gsub(/COVERPICTURE/, render_cover_picture)\
              .gsub(/COMMENTS/, render_comments)\
              .gsub(/BUTTONS/, render_buttons)\
              .gsub(/ATTACHMENTS/, render_attachments)\
              .gsub(/ATTACHMENT\[(\d)+\]/) { |attachment_number|
                attachment_number.gsub! /\D/,''
                c = self.attachments[attachment_number.to_i]
                if c
                  if c.file_content_type =~ /image/
                    @view_context.image_tag c.file.url(:medium)
                  elsif
                    @view_context.link_to( c.file_file_name, c.file.url )
                  end
                else
                  "ATTACHMENT #{attachment_number} NOT FOUND"
                end
              }\
              .gsub(/COMPONENT\[(\d)\]/) do |component_number|
                component_number.gsub! /\D/,''
                 c = self.components.where(:position => component_number.to_i).first
                 if c
                   c.render_body
                 else
                   "COMPONENT #{component_number} NOT FOUND"
                 end
              end
    end
  end

  def render_components
    self.page_components.asc(:position).map do |component|
      if @view_context
        component.render_body(@view_context)
      else
        component.body || ''
      end
    end.join("\n")
  end

  def render_comments
    if @view_context
      @view_context.render( :partial => 'pages/comments', :locals => {:page => self} )
    else
      ""
    end
  end

  def render_attachments
    if @view_context
      @view_context.render( :partial => 'pages/attachments', :locals => {:page => self })
    else
      ""
    end
  end

  def render_cover_picture
    if self.cover_picture_exists?
      @view_context.image_tag self.cover_picture.url(:medium)
    end
  end

  def render_buttons
    @view_context.render :partial => "pages/buttons", :locals => { :page => self }
  end

end
