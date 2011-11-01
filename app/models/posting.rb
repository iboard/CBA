# -*- encoding : utf-8 -*-

# A Posting is a blogabble semi-static content-item.
class Posting
  include ContentItem
  acts_as_content_item
  has_cover_picture
  
  # Fields ======================================================
  referenced_in         :user, :inverse_of => :postings
  field                 :user_id
  validates_presence_of :user_id

  field                 :body, :required => true
  validates_presence_of :body

  field                 :interpreter, :default => :markdown

  # Associations  ================================================
  referenced_in         :blog, :inverse_of => :postings

  references_many       :comments, :inverse_of => :commentable, :as => 'commentable'
  validates_associated  :comments


  # TODO: Move this definitions to a library-module
  # TODO: and replace this lines with just 'has_attchments'
  embeds_many           :attachments
  validates_associated  :attachments
  accepts_nested_attributes_for :attachments,
                                :allow_destroy => true
                                



  # Send notifications
  after_create  :send_notifications

  # Full-text-search
  include Mongoid::FullTextSearch
  fulltext_search_in :fulltext, :index_name => 'site_search'
  def fulltext
    title + " " + body + " " + comments.map(&:comment).join(" ")
  end

  scope :rss_items, lambda { not_in( is_draft: [true,nil]) }


  # Render the body
  def render_body(view_context=nil)
    @view_context ||= view_context
    if @view_context
      @view_context.concat render_for_html(self.body).html_safe
      return ""
    else
      render_for_html(self.body).html_safe
    end
  end
  
  def new_tag
  end
  
  def new_tag=(new_tag)
    unless new_tag.blank?
      self.tags_array += [new_tag]
      self.tags_array.uniq!
    end
  end


private ################################################## private ####

  # Render the intro (which is the first paragraph of the body)
  def content_for_intro(interpret=true)
    if interpret
      render_for_html(body.paragraphs[0])
    else
      body.paragraphs[0]
    end
  end

  # Send a notification to admins when a new posting was created
  def send_notifications
    DelayedJob.enqueue('NewPostingNotifier',
      Time.now + (CONSTANTS['delay_comment_notifications'].to_i).seconds,
      self.blog.id, self.id
    )
  end


end

