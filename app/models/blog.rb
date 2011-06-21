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

  has_and_belongs_to_many :pages # This pages will be displayed in blog:show
  after_save :remove_from_old_pages

  def page_tokens=(tokens)
    @pages_before = self.pages.all
    self.pages = Page.criteria.for_ids(tokens.split(','))
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

  private
  # ContentItems need to override the abstract method but a Blog didn't
  def content_for_intro
    # TODO: Intro should link to a Page if one is referenced.
  end
  
  def remove_from_old_pages
    if @pages_before
      @pages_before.each do |old_page|
        unless self.pages.include?(old_page)
          old_page.blogs -= [self]
          old_page.save
        end
      end
    end
  end
end