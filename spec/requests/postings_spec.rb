require File::expand_path('../../spec_helper', __FILE__)

describe "Postings:" do

  before(:all) do
    cleanup_database
    create_default_userset
    @blog = Blog.create title: 'News', is_draft: false
  end

  describe "should be visible for recipients only" do

    before(:all) do
      @recipient_1 = User.where( name: 'testmax' ).first
      @recipient_2 = User.where( name: 'Author' ).first
      @post_1 = @blog.postings.create title: 'For user only', body: 'For your eyes only',
        is_draft: false, user: User.first, recipient_ids: [@recipient_1.id]
      @post_2 = @blog.postings.create title: 'For user and moderator', body: 'Not for author',
        is_draft: false, user: User.first, recipient_ids: [@recipient_1.id, @recipient_2.id]
      @post_3 = @blog.postings.create title: 'Public Posting', body: 'This is public',
          is_draft: false, user: User.first
      @blog.save!
    end

    it "should show post 1,2, and 3 to user" do
      pending "To be done when groups are fully implemented"
      #log_in_as "user@iboard.cc", "thisisnotsecret"
      #visit blog_posting_path(@blog,@post_1)
      #page.should have_content "For user only"
      #visit blog_posting_path(@blog,@post_2)
      #page.should have_content "For user and moderator"
      #visit blog_posting_path(@blog,@post_3)
      #page.should have_content "Public Posting"
    end

    it "should hide @post_1 and @post_2 from public" do
      visit blog_posting_path(@blog,@post_1)
      page.should have_no_content "For user only"
      page.should have_content "You are not authorized to access this page"
      visit blog_posting_path(@blog,@post_2)
      page.should have_no_content "For user and moderator"
      page.should have_content "You are not authorized to access this page"
    end

    it "should hide @post_1 and 2 from author" do
      pending "To be done when groups are fully implemented"
      #log_in_as "author@iboard.cc", "thisisnotsecret"
      #visit blog_posting_path(@blog,@post_1)
      #page.should have_no_content "For user only"
      #page.should have_content "You are not authorized to access this page"
      #visit blog_posting_path(@blog,@post_2)
      #page.should have_content "For user and moderator"
      #page.should have_no_content "You are not authorized to access this page"
    end

  end


end