require File::expand_path('../../spec_helper', __FILE__)

describe "Test postings / homepage as an admin" do

  describe "Test hover-menus for admin when reading posts" do
    it "should show the admin-menu if mouseover title", :js => true do
      cleanup_database
      create_default_userset
      create_posting_for('admin@iboard.cc',
        :title => 'My first posting',
        :body  => 'This is my very first posting',
        :is_draft => false)
      log_in_as "admin@iboard.cc", 'thisisnotsecret'
      visit root_path
      page.should have_content("My first posting")
      begin
        page.find_link("My first posting").trigger('mouseover')
      rescue Capybara::NotSupportedByDriverError => e
        printf("!(#{e.inspect})!")
      end
    end
  end

end