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
     
  it "should round tag-weight between 0/1 and 8" do
    @blog.postings.delete_all
    10.times do |i|
      (i+1).times do |x|
        @blog.postings.create(title: "Posting #{x+1}/#{i+1}", body: "Lorem", user_id: User.first.id,
                              tags: "Weight#{x}")
      end
    end
    ContentItem::normalized_tags_with_weight(Posting).each do |tag,weight|
      assert (0..8).to_a.include?(weight), "Tag weight should be an integer between 0~8 but is #{weight}"
    end
  end

end
