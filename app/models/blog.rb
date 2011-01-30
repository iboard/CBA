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

  private
  # ContentItems need to override the abstract method but a Blog didn't
  def content_for_intro
    # TODO: Intro should link to a Page if one is referenced.
  end
end