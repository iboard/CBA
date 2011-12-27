# -*- encoding : utf-8 -*-

# A Page is a blogabble semi-static content-item.
#
# If <code>show_in_menu</code> is set the page will have a link in the
# application menu.
#
# Pages can be addressed by <code>/pages/OBJECT_ID</code> or
# <code>/p/TITLE_OF_THE_PAGE</code>. It can have comments and a 'cover-picture'
require File.expand_path("../../../lib/translator/translator", __FILE__)
class Page
  include ContentItem
  acts_as_content_item
  has_cover_picture
  include Translator
  translate_fields [:title, :body]


  field :show_in_menu, :type => Boolean, :default => true
  field :menu_order, :type => Integer, :default => 99999
  field :body, :type => String, :required => true
  validates_presence_of :body

  field :interpreter,                             :default => :markdown
  field :allow_comments,        :type => Boolean, :default => true
  field :allow_public_comments, :type => Boolean, :default => true
  field :is_template,           :type => Boolean, :default => false
  field :template_id,           :type => BSON::ObjectId, :default => nil

  # Flags
  field :allow_removing_component, :type => Boolean, :default => true

  # Full-text-search
  include Mongoid::FullTextSearch
  fulltext_search_in    :fulltext, :index_name => 'site_search'
  def fulltext
    [
      title,
      body,
      comments.map(&:comment).join(" "),
      (page_components.any? ? page_components.map{|c| c.body}.join(" ") : "")
    ].join(' ')
  end

  scope :rss_items, lambda { not_in( is_draft: [true,nil]) }

  # If this page is derived from a Page(Template) this method returns the
  # template-page
  def template
    if self.template_id
      Page.templates.find(self.template_id)
    else
      nil
    end
  end

  # Set the template id
  # @param [Page] new_template is the page to be used as template for this page
  def template=(new_template)
    if new_template
      self.template_id = new_template.id
    else
      self.template_id = nil
    end
  end

  # Set the template by name
  # @param[String] new_template the name of the new template
  def template_by_name=(new_template)
    self.template_id = PageTemplate.where(:name => new_template).first.id
  end

  # @return [Boolean] true if this page is derived from another page and the original page still exists!
  def derived?
    return self.template_id != nil && self.template != nil
  end

  default_scope lambda { online.where( is_template: false) }
  scope :templates, lambda { online.where(is_template: true ) }
  scope :top_pages, lambda { online.where(show_in_menu: true).asc(:menu_order) }

  references_many            :comments, :inverse_of => :commentable, :as => 'commentable'
  validates_associated       :comments

  # TODO: Move this definitions to a library-module
  # TODO: and replace this lines with just 'has_attchments
  embeds_many :attachments
  validates_associated :attachments
  accepts_nested_attributes_for :attachments, :allow_destroy => true

  embeds_many :page_components
  accepts_nested_attributes_for :page_components, :allow_destroy => true

  field :page_template_id, :type => BSON::ObjectId

  # Return the CSS PageTemplate of this page
  def page_template
    PageTemplate.where(:_id => self.page_template_id.to_s).first if self.page_template_id
  end

  # Assign a CSS Template to this Page
  def page_template=(new_template)
    self.page_template_id = new_template.id if new_template
  end

  has_and_belongs_to_many :blogs, dependent: :nullify

  # Same as short_title but will append a $-sign instead of '...'
  # ... smells in URLs and one can not see the difference if ... is just
  # part of the title or comes from truncation.
  def short_title_for_url
    title.truncate(CONSTANTS['title_max_length'].to_i, :omission => '$' )
  end

  
  # the first paragraph of the body)
  def content_for_intro
    (self.t(I18n.locale,:body)||self.body).paragraphs[0]
  end


end
