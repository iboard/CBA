require File::expand_path('../../spec_helper', __FILE__)

describe "Test editing PageComponents (inline)" do

  describe "PageComponent Edit Button" do
    
    it "renders form in overlay and submits via ajax", :js => true do
      
      # Setup data
      cleanup_database
      create_default_userset
      my_page = create_page_with_component(
        :title => 'A page with one component',
        :body  => "The page's body",
        :is_draft => false,
        :page_component => { :title => 'First Component', :body => 'This is the origin component' })
        
      # Make sure we are on the expected page
      log_in_as "admin@iboard.cc", 'thisisnotsecret'
      visit page_path(my_page)
      page.should have_content("A page with one component")
      page.should have_content("This is the origin component")
      
      # Click the Edit link and edit the component
      page.all('a', :text => 'Edit').last.click
      fill_in "Title", :with => 'A modified component'
      fill_in "Body", :with => "This is a modified component"
      click_on "Update component"
      
      # Make sure modification is displayed
      page.should have_content("A modified component")
      page.should have_content("This is a modified component")
      
    end
  end

end