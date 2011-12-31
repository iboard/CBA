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
  field :user_role,             :type => Integer, :default => 0

  # REVIEW: Why postings are referenced and not embedded?
  references_many :postings, :dependent => :delete
  validates_associated :postings

  has_and_belongs_to_many :pages, :dependent => :nullify # This pages will be displayed in blog:show
  
  scope :for_role, ->(role) { any_of( 
                                {:user_role.lte => role},
                                {:user_role => nil } 
                              )}
                              
  scope :public_blogs, any_of( 
                   {:user_role => 0},
                   {:user_role => nil} 
                 )
  
  
  # page_tokens are page::object_ids of the pages which should be
  # displayed on the sidebar of this blog.
  def page_tokens=(tokens)
    @pages_before = self.pages.unscoped
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
  
  # @return [Boolean] true if user_role is not defined or eql 0
  def public?
    self.user_role == nil || self.user_role == 0
  end

  # @param [User] _user - the current user or nil
  # @param [Symbol] _role - the current user's role
  # @param [Boolean] _draft_mode - select for draft-mode if true
  # @return [Criteria] for all visible postings for this user
  def postings_for_user_and_mode(_user,_draft_mode=false)
    # if no user is given then return only public and online postings
    unless _user
      _online =  self.postings.online.only(:id).map(&:id)
      _public =  self.postings.publics.only(:id).map(&:id) 
      _published=self.postings.published.only(:id).map(&:id) 
      return self.postings.for_ids(_online & _public & _published)
    end

    # if user is moderator and in draft_mode then return all postings
    if _draft_mode && _user.role?(:moderator)
      return self.postings.all
    end

    # The mongo-driver is not able to combine two any_of ($or) as "and"
    #
    # model.any_of( :f1 => '1', :f2 => '2').any_of( :d1 => 'x', :d2 => 'y')
    # is not equal to
    #    select * from model where ( f1 = 1 OR f2 = 2) AND ( d1 = x OR d2 = y ) 
    # but it will act as
    #    select * from model where ( f1 = 1 OR f2 = 2 OR d1 = x OR d2 = y )
    #
    # Posting scopes using any_of are:
    #   * addressed_to(user_id)
    #   * online
    
    # public or addressed to _user
    _addressed_ids = self.postings.addressed_to(_user.id).only(:id).map(&:id)
    # in range of publish_at and enxpire_at
    _online_ids = self.postings.online.only(:id).map(&:id)

    unless _user.role?(:moderator)
      unless _draft_mode
        _visible_ids = _online_ids & self.postings.published.only(:id).map(&:id) & _addressed_ids
      else
        _visible_ids = _addressed_ids
      end
    else
      _visible_ids = _online_ids & self.postings.published.only(:id).map(&:id)
    end

    self.postings.for_ids( _visible_ids )
  end
  

private
  # ContentItems need to override the abstract method but a Blog didn't
  def content_for_intro
    self.synopsis
  end

end
