require 'spec_helper'

describe "Postings should provide some helper methods" do

  before(:all) do
    cleanup_database
    create_default_userset
    @blog  = Blog.create(title: 'News')
  end
  
  before(:each) do
    @blog = Blog.first
  end
   
  it "should have an empty tags-array after creating" do
    @posting = @blog.postings.create(title: 'My first blog', body: 'Lorem', :user_id => User.first.id)
    assert_match "My first blog", @posting.title, "The posting should be initialized"
    assert @posting.tags_array == [], "Posting's tags should be an empty array after create"
  end
     
end
