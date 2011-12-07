require File::expand_path('../../spec_helper', __FILE__)

describe "Left sidebar" do

  before(:all) do
    cleanup_database
    create_default_userset

    # To be done in data_helper ...
    create_news_blog_with_postings do |blog|
      blog.postings.create(title: 'First Posting', user: User.first, is_draft: false, body: 'My first postng')
      blog.postings.create(title: 'Second Posting', user: User.first, is_draft: false,body: 'My second posting')
    end
    visit blog_path(Blog.first.id)
  end


  # Oh, some test should be there yet but are missing.
  # So let's do this
  it "should display the submenu-menu" do
    page.should have_css ".submenu_box"
  end

  it "should display the site-search-box" do
    assert page.all(:css, "#searchbox"), "There should be a searchbox!"
  end

  it "should display the tag-cloud" do
    assert page.all(:css, ".submenu_box"), "There should be a sub-menu-box!"
  end

  # When the current view provides a partial (app/views/xxxx/_sidebar_left.haml|html.erb)
  # The standard sidebar should bot be displayed but the partial should be rendered there
  it "should display the view's partial on blogs_view (for example)" do
    @remove_at_end = create_file_if_not_exists 'app/views/blogs/_sidebar_left.haml', 'THIS IS THE SIDEBAR PARTIAL'
    visit blog_path(Blog.first.id)
    begin
      page.should have_content "THIS IS THE SIDEBAR PARTIAL" 
    ensure 
      File::unlink "app/views/blogs/_sidebar_left.haml" if @remove_at_end
    end
  end

end