require 'spec_helper'

describe "ContentItem" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @user = User.first
  end

  describe "Pages" do
    before(:all) do
      @pages  = 
        [
          Page.create(is_draft: false, is_template: false, user_id: @user.id, title: 'Always online',body:'no publish_at or expire_at field'),
          Page.create(is_draft: false, is_template: false, user_id: @user.id, title: 'Expired',body:'expire_at field',expire_at: Time.now-1.hour),
          Page.create(is_draft: false, is_template: false, user_id: @user.id, title: 'Prerelease',body:'publish_at field',publish_at: Time.now+1.hour),
          Page.create(is_draft: false, is_template: false, user_id: @user.id, title: 'Current',body:'should be online', publish_at: Time.now-1.day, expire_at: Time.now+1.day)
        ]
    end

    it "should show current pages" do
      current_pages = Page.online
      assert current_pages.include?(@pages[0]), "Should include page 0"
      assert current_pages.include?(@pages[3]), "Should include page 3"
      assert !current_pages.include?(@pages[1]), "Should not include page 1"
      assert !current_pages.include?(@pages[2]), "Should not include page 2"
    end
  
    it "should list expired pages" do
      _pages = Page.unscoped.expired.all
      assert !_pages.include?(@pages[0]), "Should not include page 0"
      assert _pages.include?(@pages[1]), "Should include page 1"
      assert !_pages.include?(@pages[2]), "Should not include page 2"
      assert !_pages.include?(@pages[3]), "Should not include page 3"
    end
  
    it "should list pre_release pages" do
      _pages = Page.unscoped.pre_release
      assert !_pages.include?(@pages[0]), "Should not include page 0"
      assert !_pages.include?(@pages[1]), "Should not include page 1"
      assert _pages.include?(@pages[2]), "Should include page 2"
      assert !_pages.include?(@pages[3]), "Should not include page 3"
    end
  end

  describe "Postings" do
    before(:all) do
      @blog = Blog.create(title:"News")
      @postings = [
        @blog.postings.create(title: "Always online", body: 'both nil',user_id: @user.id),
        @blog.postings.create(title: "Prerelease", body: 'not yet', publish_at: Time.now+1.week, user_id: @user.id),
        @blog.postings.create(title: "Expired", body: 'old', expire_at: Time.now-1.week, user_id: @user.id),
        @blog.postings.create(title: "Current", body: 'latest', publish_at: Time.now-1.week, expire_at: Time.now+1.week, user_id: @user.id),
      ]
    end

    it "should show current postings" do
      _postings = @blog.postings.unscoped.online
      assert _postings.include?(@postings[0]), "Should include posting 0"
      assert !_postings.include?(@postings[1]), "Should not include posting 1"
      assert !_postings.include?(@postings[2]), "Should not include posting 2"
      assert _postings.include?(@postings[3]), "Should include posting 3"
    end
  
    it "should list expired postings" do
      _postings = @blog.postings.expired
      assert !_postings.include?(@postings[0]), "Should not include posting 0"
      assert !_postings.include?(@postings[1]), "Should not include posting 1"
      assert _postings.include?(@postings[2]), "Should include posting 2"
      assert !_postings.include?(@postings[3]), "Should not include posting 3"
    end
  
    it "should list pre_release postings" do
      _postings = @blog.postings.pre_release
      assert !_postings.include?(@postings[0]), "Should not include posting 0"
      assert _postings.include?(@postings[1]), "Should include posting 1"
      assert !_postings.include?(@postings[2]), "Should not include posting 2"
      assert !_postings.include?(@postings[3]), "Should not include posting 3"
    end

  end
end
