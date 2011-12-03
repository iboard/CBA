require File::expand_path('../../spec_helper', __FILE__)

describe "Blog" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @blog  = Blog.create(title: 'News', is_draft: false, is_template: false)
  end
      
  it "should render links with markup", :js => true do
    @blog.postings.delete_all
    posting = @blog.postings.create(
                      title: 'My first posting', 
                      body: 'Lorem ipsum [CBA Blog](http://cba.iboard.cc) dolorem', 
                      user_id:  User.first.id,
                      is_draft: false)
    posting.save!
    @blog.save!
    visit blog_path(@blog)
    sleep(4)
    page.should have_link('CBA Blog')
  end

  it "should show first paragraph only in blog view" do
    @blog.postings.delete_all
    posting = @blog.postings.create(
                      title: 'My first posting', 
                      body: "Lorem ipsum [CBA Blog](http://cba.iboard.cc) dolorem\nSecond Paragraph", 
                      user_id:  User.first.id,
                      is_draft: false)
    visit blog_path(@blog)
    page.should have_no_content "Second Paragraph"
    click_link "My first posting"
    page.should have_content "Second Paragraph"
  end
  
  it "should be hidden if user-role doesn't match" do
    restricted_blog = Blog.create(title: 'Restricted', is_draft: false, is_template: false, user_role: 1)
    posting = restricted_blog.postings.create(
                      title: 'My secret posting', 
                      body: 'not for the public', 
                      user_id:  User.first.id,
                      is_draft: false)
    visit blog_path(restricted_blog)
    page.should have_content "404 - Content not found"
  end
  
  it "opening for edit and save without making changes should not change anything (Bugfix: PT#21801945)" do
    blog = Blog.create(title: 'Restricted users', is_draft: false, is_template: false, user_role: 1)
    _saved_attributes = blog.attributes.dup
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    visit edit_blog_path(blog)
    click_button "Update Blog"
    visit blog_path(blog)
    blog.reload
    _changed_attributes = blog.attributes
    _changed_attributes.delete('updated_at')
    _changed_attributes.each do |key, value|
      unless _saved_attributes[key].to_s.eql?( value.to_s )
        puts "ATTRIBUTE CHANGED: #{key.to_s} was #{_saved_attributes[key]} and changed to #{value}"
      end
      assert _saved_attributes[key].to_s.eql?( value.to_s ), "Attribute should not change "
    end
  end
  


end