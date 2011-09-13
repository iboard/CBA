# -*- encoding : utf-8 -*-

# A Blog is a collection of Postings which may or may not references a
# 'ContentItem' (eg Page).
# When a Blog references a Page, the Page sould be seen as the 'Intro' to
# this blog.

class Blog
  include ContentItem
  acts_as_content_item
  has_cover_picture

  field :allow_comments,        :type => Boolean, :default => true
  field :allow_public_comments, :type => Boolean, :default => true
  field :synopsis
  
  

  # REVIEW: Why postings are referenced and not embedded?
  references_many :postings, :dependent => :delete
  validates_associated :postings
  after_save :remove_from_old_pages

  has_and_belongs_to_many :pages, :dependent => :nullify # This pages will be displayed in blog:show

  # page_tokens are page::object_ids of the pages which should be
  # displayed on the sidebar of this blog.
  def page_tokens=(tokens)
    @pages_before = self.pages.unscoped.all
    self.pages.nullify
    self.pages.push(Page.criteria.for_ids(tokens).all)
  end

  # Create a posting with attachments from params for current_user
  def create_posting(form_params,current_user)
    posting = self.postings.create(form_params)
    posting.user = current_user
    if posting.save && self.save
      posting.attachments.each(&:save) if posting.attachments
    end
    posting
  end

  # find postings with filter
  #
  # @param [Hash] options a filter to find postings of this blog e.g. '{ is_draft: true }'
  # @return [Criteria] Criteria on self.postings.where( _options_ )
  def scoped_postings(options=nil)
    return self.postings unless options
    self.postings.unscoped.where( options )
  end

  # find pages with filter
  # @param [Hash] options a filter to find pages of this blog e.g. '{ is_draft: true }'
  # @return [Criteria] Criteria on self.pages.where( _options_ )
  def scoped_pages(options=nil)
    return self.pages unless options
    self.pages.where( options )
  end

  private
  # ContentItems need to override the abstract method but a Blog didn't
  def content_for_intro
    # TODO: Intro should link to a Page if one is referenced.
  end

  # Remove this blog from pages which should not be displayed with this
  # blog
  def remove_from_old_pages
    if @pages_before
      @pages_before.each do |old_page|
        unless self.pages.unscoped.include?(old_page)
          old_page.blogs -= [self]
          old_page.save
        end
      end
      @pages_before = []
    end
  end
  
end
