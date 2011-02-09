# A Blog is a collection of Postings which may or may not references a 
# 'ContentItem' (eg Page). 
# When a Blog references a Page, the Page sould be seen as the 'Intro' to
# this blog.

class Blog 
  include ContentItem
  acts_as_content_item
  has_cover_picture
  
  references_many :postings, :dependent => :delete
  validates_associated :postings

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
end