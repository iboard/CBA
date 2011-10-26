require File::expand_path('../../spec_helper', __FILE__)

describe "Blog" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @blog  = Blog.create(title: 'News', is_draft: false, is_template: false)
  end
      
  it "should render links with markup" do
    @blog.postings.delete_all
    posting = @blog.postings.create(
                      title: 'My first posting', 
                      body: 'Lorem ipsum [CBA Blog](http://cba.iboard.cc) dolorem', 
                      user_id:  User.first.id,
                      is_draft: false)
    visit blog_path(@blog.id.to_s)
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


end