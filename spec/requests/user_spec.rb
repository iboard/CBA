require File::expand_path('../../spec_helper', __FILE__)

describe "Users and registrations" do
  
  before(:all) do
    cleanup_database
    create_default_userset
  end
      
  it "Users should paginate sorted" do
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    visit registrations_path
    click_link "by name"
    page.should have_content "admin"
    page.should have_content "Author"
    click_link "by date created"
    page.should have_content "admin"
    page.should have_content "testmax"
  end
  
end