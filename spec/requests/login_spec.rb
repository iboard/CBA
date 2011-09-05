require 'spec_helper'

describe "Login" do

  describe "GET /users/sign_in" do
    
    it "invalid login's should show up an error" do
      visit new_user_session_path
      fill_in "Email", :with => 'Some@Stranger.To'
      fill_in "Password", :with => 'IdontKnow'
      click_button "Sign in"
      page.should have_content('Invalid email or password.')
    end

    it "valid login should show the home page" do
      SpecDataHelper::cleanup_database
      SpecDataHelper::create_default_userset
      SpecDataHelper::with_user 'admin@iboard.cc' do |user|
        visit new_user_session_path
        fill_in "Email", :with => user.email
        fill_in "Password", :with => 'thisisnotsecret'
        click_button "Sign in"
      end
      page.should have_content('Signed in successfully.')
    end
    
  end

end