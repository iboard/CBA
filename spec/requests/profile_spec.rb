require File::expand_path('../../spec_helper', __FILE__)

describe "User-profile:" do

  before(:all) do
    cleanup_database
    create_default_userset
  end

  describe "Admin and maintainer"
  
    it "should see profile of other users" do
      log_in_as "admin@iboard.cc", "thisisnotsecret"
      visit user_path(User.where(email: 'user@iboard.cc').first.to_param)
      page.should have_content "testmax"
      page.should_not have_content "Your Account"
    end

  describe "Normal users" do
  end
  
  describe "Bugfix - Edit user-role will not select current value" do
    it "should not change the role when saving without selecting a new role" do
      log_in_as "admin@iboard.cc", "thisisnotsecret"
      test_user = User.where(email: 'user@iboard.cc').first
      attributes_before = test_user.attributes
      visit edit_role_user_path(test_user)
      click_button "Update User"
      assert !attributes_changed?(test_user,attributes_before), "Attributes should not change"
    end
  end

end