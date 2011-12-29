require File::expand_path('../../spec_helper', __FILE__)

describe "Page" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @_page = Page.create title: 'Test Page', is_draft: false, is_template: false, body: 'Test Page'
    @_page.save!
  end


  describe "Publish at" do
    it "Should provide a publish_at field" do
      log_in_as "admin@iboard.cc", "thisisnotsecret"
      visit page_path(@_page)
      page.all('a',:text => 'Edit').first.click()
      page.should have_field 'page_publish_at_date'
      page.should have_field 'page_publish_at_time'
    end

    it "Should hide unpublished pages" do
      log_in_as "admin@iboard.cc", "thisisnotsecret"
      visit page_path(@_page)
      page.all('a',:text => 'Edit').first.click()
      fill_in 'page_publish_at_date', with: (Time.now+1.minute).strftime("%Y-%m-%d")
      fill_in 'page_publish_at_time', with: (Time.now+1.minute).strftime("%H.%M")
      click_button "Update Page"
      page.should have_content "Page was successfully updated."
      visit pages_path
      page.should_not have_content "Test Page"
    end

    it "Should hide expired pages" do
      log_in_as "admin@iboard.cc", "thisisnotsecret"
      visit page_path(@_page)
      page.all('a',:text => 'Edit').first.click()
      fill_in 'page_publish_at_date', with: (Time.now-20.minutes).strftime("%Y-%m-%d")
      fill_in 'page_publish_at_time', with: (Time.now-20.minutes).strftime("%H.%M")
      fill_in 'page_expire_at_date', with: (Time.now-10.minutes).strftime("%Y-%m-%d")
      fill_in 'page_expire_at_time', with: (Time.now-10.minutes).strftime("%H.%M")
      sleep 1
      click_button "Update Page"
      sleep 1
      page.should have_content "Page was successfully updated."
      visit pages_path
      sleep 2
      page.should_not have_content "Test Page"
    end
  end
    
  describe "PageComponents" do
    
    before(:all) do
      @_component = @_page.page_components.create(title: 'Component One', body: 'Component Body')
    end
    
    it "remove component link should be hidden in overlay-tag", :js => true do
      log_in_as 'admin@iboard.cc', 'thisisnotsecret'
      visit page_path(@_page.id.to_s)
      page.all('.page-component-edit a', text: 'Edit' ).first.click()
      sleep 1
      page.should_not have_link 'Destroy Component'
    end
  end

end