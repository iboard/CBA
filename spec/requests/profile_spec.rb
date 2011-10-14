require 'spec_helper'

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

end