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
  
  it "should be visible for addressee only" do
    recipient_1 = User.where(name: 'testmax').first
    recipient_2 = User.where(name: 'Moderator').first
    no_recipient = User.where(name: 'maintainer').first
    @posting = @blog.postings.create(
      title: 'For testmax only', body: 'Lorem', :user_id => User.first.id,
      recipient_ids: [recipient_1.id,recipient_2.id]
    )
    assert @posting.has_recipient?(recipient_1), "testmax should be a recipient of this posting"
    assert @posting.has_recipient?(recipient_2), "moderator should be a recipient of this posting"
    assert !@posting.has_recipient?(no_recipient), "maintainer should not be a recipient of this posting"
  end
  

end
