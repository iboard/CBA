require 'spec_helper'

describe "Login" do
  
  describe "GET /users/sign_in" do
    
    it "should not be possible to login with invalid credentials" do
      visit new_user_session_path
      fill_in "Email", :with => 'Some@Stranger.To'
      fill_in "Password", :with => 'IdontKnow'
      click_button "Sign in"
      page.should have_content('Invalid email or password.')
    end

    it "should be possible to login as admin@iboard.cc" do
      cleanup_database
      create_default_userset
      log_in_as "admin@iboard.cc", 'thisisnotsecret'
      page.should have_content('Signed in successfully.')
    end
    
  end

end