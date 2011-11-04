require File::expand_path('../../spec_helper', __FILE__)

describe "HomeController:" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @news        = Blog.create(title: 'News', is_draft: false )
    @public_blog = Blog.create(title: 'Public Blog', is_draft: false)
    @private_blog= Blog.create(title: 'Private Blog', is_draft: false, user_role: 1)
    
    @news.postings.create(
      title: 'A News Posting', is_draft: false, user: User.first,
      body: 'This is a public posting in blog News', tags: 'PubPost,NewsTag'
    )
    @public_blog.postings.create(
      title: 'A Public Posting', is_draft: false, user: User.first,
      body: 'This is a public posting in blog Public', tags: 'PubPost'
    )
    @private_blog.postings.create(
      title: 'A Private Posting', is_draft: false, user: User.first,
      body: 'This is a private posting in blog Private', tags: 'PrivPost'
    )
    visit root_path
  end
      
  describe "For unauthorized users" do    
    it "should list public postings of blog News in root_path" do
      page.should have_content "A News Posting"
    end
    it "should not list private postings in root_path" do
      page.should have_no_content "A Private Posting"
    end
    
    describe "Blog index" do    
      it "should list public blogs in blogs index" do
        visit blogs_path
        page.should have_content "News"
        page.should have_content "Public Blog"
      end
      it "should not list private blogs in blogs index" do
        visit blogs_path
        page.should have_no_content "Private Blog"
      end
    end

    describe "Blog::show View" do
      it "should list public postings in blog public" do
        visit blog_path(@public_blog)
        page.should have_content "A Public Posting"
      end
      it "should not list private blog and postings" do
        visit blog_path(@private_blog)
        page.should have_no_content "Private Blog"      
        page.should have_no_content "A Private Posting"
      end      
    end
  end 


  describe "For authorized users" do
    before(:each) do
      log_in_as "user@iboard.cc", "thisisnotsecret"
      visit root_path
    end
    
    describe "Blog index" do
      before(:each) do
        visit blogs_path
      end
      it "Should list all blogs" do
        page.should have_content "News"
        page.should have_content "Public Blog"
        page.should have_content "Private Blog"
      end
    end
    
    describe "Private Blog Show-view" do
      it "should list private postings" do
        visit blog_path(@private_blog)
        page.should have_content "A Private Posting"
      end
    end
  end
  
  
  describe "TagCloud" do
    describe "For unauthorized users" do
      it "should show public posting through PubPost Tag" do
        visit root_path
        click_link "PubPost"
        page.should have_content "A Public Posting"
      end
      it "should not show private posting through PrivPost Tag" do
        visit root_path
        page.should have_no_link "PrivPost"
      end
      it "should not list private postings for tag PrivPost" do
        visit tag_path('PrivPost')
        page.should have_no_content "A Private Posting"
      end
    end
  end


end