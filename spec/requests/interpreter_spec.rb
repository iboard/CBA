require 'spec_helper'

describe "Interpreter" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @page_template = PageTemplate.create(
     name: 'Default',
     html_template: "<h2>TITLE</h2><div style='clear: right; float: right; 
                     margin-left: 10px; margin-bottom: 10px;'>COVERPICTURE</div>
                     <address class='inline_buttons'>BUTTONS</address>
                     <div class='page_body'>BODY</div>
                     <div class='page_attachments'>ATTACHMENTS</div>
                     <div class='page_components'>COMPONENTS</div>
                     <div class='page_comments'>COMMENTS</div>",
     css_class: 'default'
    )
        
    @blog  = Blog.create(title: 'News')
    @posting = @blog.postings.create(title: 'My first posting', body: 'Lorem ipsum', 
                                     user_id:  User.first.id, 
                                     tags: 'Hello,world')
    @page = Page.create(title: 'A page with components',
                        body: 'This is a [wonderful body](http://iboard.cc)',
                        is_template: false,
                        is_draft: false,
                        page_template_id: @page_template.id)
    @page.translate!
    @component = @page.page_components.create(
      position: 1, 
      title: 'First component',    
      body: 'This is the first component'
    )
  end
      
  it "Page with component should render correct" do
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    visit page_path(@page)
    # Check we are on the right page
    page.should have_content "A page with components"
    page.should have_content "This is a wonderful body"
    page.should have_link "Edit"
    # Check Rendering 
    assert page.document.text !~  /<p>/, "Page should not escape <>"
  end
  
  it "Page intro on blog::show should render with markdown" do
    @page.blogs << @blog
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    visit blog_path(@blog)
    page.should have_link "wonderful body"
  end  
  
  it "should interpret LOCATION and PLACES tags with google-maps" do
    @page.body = "A [LOCATION:48.2165,14.2618] and a [PLACE:Technisches Museum, Wien]"
    @page.save!
    visit page_path(@page)
    page.should have_link "48.2165,14.2618"
    page.should have_link "Technisches Museum, Wien"
  end
  
  it "should open a google-map in overlay", :js => true do 
    @page.body = "A [LOCATION:48.2165,14.2618] and a [PLACE:Technisches Museum, Wien]"
    @page.save!
    visit page_path(@page)
    click_link "48.2165,14.2618"
    sleep 1
    page.find('#label').should have_content "48.2165,14.2618"
    page.find("#map").should have_content "Google"
    page.find('#map-container').click_link "close"
    assert page.find('#overlay').visible? == false, "Overlay sould close"
  end
  
  it "map in overlay should provide a link to google-maps", :js => true do
    @page.body = "A [LOCATION:48.2165,14.2618] and a [PLACE:Technisches Museum, Wien]"
    @page.save!
    visit page_path(@page)
    click_link "Technisches Museum, Wien"
    sleep 1
    page.should have_link "Google maps..."
  end
  
  
  
end