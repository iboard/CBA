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
    
    it "should show it's limited in blog- and posting-view" do
      log_in_as "user@iboard.cc", "thisisnotsecret"
      visit blog_path(@blog)
      page.should have_content "Limited"
      visit blog_posting_path(@blog,@post_1)
      page.should have_content "Limited"
    end

    it "should show post 1,2, and 3 to user" do
      log_in_as "user@iboard.cc", "thisisnotsecret"
      visit blog_posting_path(@blog,@post_1)
      page.should have_content "For user only"
      visit blog_posting_path(@blog,@post_2)
      page.should have_content "For user and moderator"
      visit blog_posting_path(@blog,@post_3)
      page.should have_content "Public Posting"
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
      log_in_as "author@iboard.cc", "thisisnotsecret"
      visit blog_posting_path(@blog,@post_1)
      page.should have_no_content "For user only"
      page.should have_content "You are not authorized to access this page"
      visit blog_posting_path(@blog,@post_2)
      page.should have_content "For user and moderator"
      page.should have_no_content "You are not authorized to access this page"
    end
    
    it "should hide limited postings in blog show" do
      visit blog_path(@blog)
      page.should have_no_content "Limited"
    end
    
    it "Should hide unpublished postings" do
      log_in_as "admin@iboard.cc", "thisisnotsecret"
      _unpublished = @blog.postings.create(title:'unpublished posting',user_id: User.first.id,is_draft: false,publish_at: Time.now+2.minutes)
      visit blog_path(@blog)
      page.should_not have_content "unpublished posting"
    end
    
    it "Should hide expired postings" do
      log_in_as "admin@iboard.cc", "thisisnotsecret"
      _expired = @blog.postings.create(title:'expired posting',user_id: User.first.id,is_draft: false,expire_at: Time.now-2.minutes)
      visit blog_path(@blog)
      page.should_not have_content "expired posting"
    end

    it "should interpret when rendering with a view-context", js: true do
      @blog.postings.first.tap do |posting|
        posting.body = "AN IMAGE  ATTACHMENT:1 AND A VIDEO ATTACHMENT:2"
        posting.recipient_ids = []
        posting.recipient_ids = []
        posting.save
      end
      @blog.save
      visit posting_path(@blog.postings.first)
      page.should have_content "ATTACHMENT 0 NOT FOUND"
      page.should have_content "ATTACHMENT 1 NOT FOUND"
    end
    
    it "should not produce a hickup with textile (Bugfix)" do
      posting = @blog.postings.create(title: "This uses textile", 
        body: "Should render without 500", user_id: User.first.id, interpreter: :textile,
        is_draft: false)
      visit posting_path(posting)
      page.should have_content "This uses textile"
      page.should have_content "Should render without 500"
    end
    
    it "should render and higlight comments" do
      posting = @blog.postings.create(title: "This contains code", 
        body: "this is ruby\n\n```ruby\nputs 'Hello World'\n```\n\n", user_id: User.first.id, interpreter: :markdown,
        is_draft: false)
      visit posting_path(posting)
      assert page.all('.s1').length > 0, 'There should be some highlight' 
      assert page.all('.s1').first.text =~ /Hello World/, 'Should highlight ruby-code'
    end

  end


end