require File::expand_path('../../spec_helper', __FILE__)

describe "Page" do
  
  before(:all) do
    cleanup_database
    create_default_userset
    @_page = Page.create title: 'Test Page', is_draft: false, is_template: false, body: 'Test Page'
    @_page.save!
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