require 'spec_helper'

describe "User notificatons:" do

  before(:all) do
    cleanup_database
    create_default_userset
  end

  it "standard users should not be authorized to write new messages" do
    log_in_as "user@iboard.cc", "thisisnotsecret"
    visit new_user_notification_path
    page.should have_content "not authorized"
  end

  describe "Admin or maintainer" do

    before(:each) do
      log_in_as "admin@iboard.cc", 'thisisnotsecret'
    end

    it "should be possible to enter new notificatons" do
      visit new_user_notification_path
      page.should have_content 'New User Notification'
    end

    it "should deliver to all users" do
      visit new_user_notification_path
      fill_in "user_notification_recipient", with: ""
      fill_in "user_notification_message", with: "Hello User"
      click_button "Submit"
      page.should have_content "Message successfully sent"
      User.all.each do |usr|
        log_out
        log_in_as usr.email, "thisisnotsecret"
        visit root_path
        page.should have_content "Hello User"
      end
    end
    
    it "should deliver to special users" do
      visit new_user_notification_path
      fill_in "user_notification_recipient", with: "user@iboard.cc,maintainer@iboard.cc"
      fill_in "user_notification_message", with: "Hello U2"
      click_button "Submit"
      page.should have_content "Message successfully sent"
      for usr in ['user@iboard.cc','maintainer@iboard.cc']
        log_out
        log_in_as usr, "thisisnotsecret"
        visit root_path
        page.should have_content "Hello U2"
      end
      log_out
      log_in_as "staff@iboard.cc", "thisisnotsecret"
      visit root_path
      page.should_not have_content "Hello U2"
    end
  end
end