require 'spec_helper'

describe "SiteMenu" do

  before(:all) do
    cleanup_database
    create_default_userset
  end
  
  it "should be created by admin" do
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    visit new_site_menu_path
    fill_in "site_menu_name", :with => "To Home"
    fill_in "site_menu_target", :with => "/"
    select "-- public --", :from => "site_menu_role_needed"
    click_button "Create Site menu"
    page.should have_content "Menu entry successfully created"
    page.should have_link "To Home"
  end
  
  it "should not display for unmatched roles" do
    SiteMenu.delete_all
    menu = SiteMenu.create( name: 'Admin', target: '/user_registrations', role_needed: User.first.roles_mask)
    log_in_as "user@iboard.cc", "thisisnotsecret"
    page.should have_no_link "Admin"
    log_out
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    page.should have_link "Admin"
  end

end
