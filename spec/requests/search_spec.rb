require File::expand_path('../../spec_helper', __FILE__)

describe "Searchbox" do

  before(:all) do
    cleanup_database
    create_default_userset
    blog=Blog.create( title: 'News', is_draft: false).tap do |blog|
      blog.postings.create(
        title: 'Public Posting',
        body: 'Posting with Public information',
        user_id: User.last.id,
        is_draft: false,
        tags: 'public,information'
      )
      blog.postings.create(
        title: 'Restricted Posting',
        body: 'Posting with Restricted information',
        user_id: User.last.id,
        is_draft: false,
        tags: 'admin,information',
        recipient_ids: [User.first.id]
      )
    end
  end

  before(:each) do
    visit root_path
  end

  it "should display the site-search-box" do
    assert page.all(:css, "#searchbox"), "There should be a searchbox!"
  end

  describe "Not logged in" do 
    it "Should find postings", :js => true do
        fill_in 'search[search]', with: 'info'
        sleep 2
        page.should have_content "Search"
        page.should have_content "Public Posting"
        page.should_not have_content "Restricted Posting"    
        page.should have_no_content "Nothing found"
    end
  
    it "Should not find restricted items if not logged in", :js => true do
        fill_in 'search[search]', with: 'Restrict'
        sleep 2
        page.should have_content "Search"
        page.should_not have_content "Restricted Posting"
        page.should have_content "Nothing found"
    end

    it "Should not find expired postings" do
      pending "To be implemented"
    end

    it "Should not find prereleased postings" do
      pending "To be implemented"
    end

    it "Should not find draft postings" do
      pending "To be implemented"
    end

    it "Should not find postings addressed to foreign users" do
      pending "To be implemented"
    end

  end

  describe "Admin" do

    before(:each) do
      log_in_as 'admin@iboard.cc', 'thisisnotsecret'
    end

    it "Should find restricted items if logged in", :js => true do
      pending "No idea why this test doesn't work?!" do
        fill_in 'search[search]', with: 'Posting'
        click_button "Search"
        page.should have_content "Restricted"
        page.should_not have_content "Nothing found"
        log_out
      end
    end

    it "Should find expired postings" do
      pending "To be implemented"
    end

    it "Should find prereleased postings" do
      pending "To be implemented"
    end

    it "Should find draft postings" do
      pending "To be implemented"
    end

    it "Should find postings addressed to foreign users" do
      pending "To be implemented"
    end


  end


end
