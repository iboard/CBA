require 'spec_helper'

describe "Tags" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @blog  = Blog.create(title: 'News')
    @posting = @blog.postings.create(title: 'My first posting', body: 'Lorem ipsum', 
                                     user_id:  User.first.id, 
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
  
end