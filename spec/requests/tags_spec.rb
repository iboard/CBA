require File::expand_path('../../spec_helper', __FILE__)

describe "Tags" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @blog  = Blog.create(title: 'News')
    @posting = @blog.postings.create(title: 'My first posting', body: 'Lorem ipsum', 
                                     user_id:  User.first.id, is_draft: false,
                                     tags: 'Hello,world')
  end
      
  it "should be rendered as a tag-cloud below the menue" do
    visit root_path
    page.should have_link('Hello')
    page.should have_link('world')
  end
  
  it "should lead to a list of postings when clicking a tag" do
    visit root_path
    click_link 'Hello'
    page.should have_content( "My first posting" ), "My first posting should be shown for tag 'Hello'"
  end

  it "should not list tags of restricted items" do
    @blog.postings.delete_all
    public_post = @blog.postings.create(
      title: 'Public Posting',
      body: 'Public information',
      user_id: User.last.id,
      is_draft: false,
      tags: 'public,information'
    )
    restricted_post = @blog.postings.create(
      title: 'Restricted Posting',
      body: 'Public information',
      user_id: User.last.id,
      is_draft: false,
      tags: 'admin,information',
      recipient_ids: [User.first.id]
    )
    visit root_path
    page.should_not have_content 'Restricted Posting'
    page.should_not have_content 'admin'
    page.should have_content 'Public information'
    page.should have_content 'public'
  end
  
end