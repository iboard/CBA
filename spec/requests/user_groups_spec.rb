require File::expand_path('../../spec_helper', __FILE__)

describe "User groups:" do

  before(:all) do
    cleanup_database
    create_default_userset
    @friends = [ 
                 User.where(email: 'user@iboard.cc').first.id,
                 User.where(email: 'maintainer@iboard.cc').first.id
               ]
  end
  
  it "should be reachable from user's-profile" do
    user = User.first
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    visit profile_path(user)
    page.should have_link "Your groups"
  end

  it "should be defined by user" do
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    visit user_user_groups_path(User.first)
    page.should have_content "No user groups defined"
    click_link "Add user group"
    fill_in "user_group_name", with: 'Friends'
    fill_in "user_group_member_tokens", with: @friends.map{|i| i.to_s}.join(", ")
    click_button "Create User group"
    page.should have_content "User group successfully created"
    page.should have_content "Friends"
    page.should have_content "testmax"
    page.should have_content "maintainer"
  end
  
  it "should autocomplete members", :js => true do
    pending "How to test autocomplete?! fill_in submits names instead of ids"
   #  user = User.first
   #  user.user_groups.delete_all
   #  user.save!
   #  log_in_as "admin@iboard.cc", "thisisnotsecret"
   #  visit new_user_user_group_path(User.first)
   #  fill_in "user_group_name", with: 'Friends'
   #  fill_in "user_group_member_tokens", "testmax"
   #  click_button "Create User group"
   #  page.should have_content "User group successfully created"
   #  page.should have_content "Friends"
   #  page.should have_content "testmax"
  end
  
  it "should allow editing group" do
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    user = User.first
    user.user_groups.delete_all
    user.user_groups.create(name: 'Friends', members: @friends)
    user.save
    visit user_user_groups_path(user)
    click_link "Edit"
    fill_in "user_group_name", with: 'Real Friends'
    click_button "Update User group"
    page.should have_content "User group successfully updated"
    page.should have_content "Real Friends"
    page.should have_content "testmax"
  end
  
  it "should have a delete group button", :js => true do
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    user = User.first
    user.user_groups.delete_all
    user.user_groups.create(name: 'Friends', members: @friends)
    user.save
    visit user_user_groups_path(user)
    page.should have_content "Friends"
    page.should have_content "testmax"
    page.find('a', text: 'Delete').click()
    page.driver.browser.switch_to.alert.accept
    sleep 1
    page.should have_content "User group successfully deleted"
    page.should have_no_content "Friends"
    page.should have_no_content "testmax"
  end
  
  it "should not be possible to view and edit foreign user's groups" do
    user = User.where(email: 'user@iboard.cc').first
    admin= User.first
    log_in_as "user@iboard.cc", "thisisnotsecret"
    visit user_user_groups_path(user)
    page.should have_content 'User groups of "testmax"'
    visit user_user_groups_path(admin)
    page.should have_content 'You are not authorized to access this page.'
  end
  
  it "should provide a restriction field" do
    # prepare
    log_in_as "admin@iboard.cc", "thisisnotsecret"
    user = User.first
    user.user_groups.delete_all
    @group = user.user_groups.create(name: 'Friends', members: @friends)
    user.save
    Blog.delete_all
    @blog = Blog.create( title: 'News', is_draft: false)
    @posting = @blog.postings.create(is_draft: false, title: 'Limited Posting', body: 'Lorem', :user_id => User.first.id)
    
    # Enter a recipient group
    visit edit_blog_posting_path(@blog,@posting)
    fill_in "posting_recipient_tokens", with: @group.id.to_s
    click_button "Update Posting"
    log_out
    
    # a friend should see the posting
    log_in_as "user@iboard.cc", "thisisnotsecret"
    visit blog_posting_path(@blog,@posting)
    page.should have_content "Limited Posting"
    
    # guests should not
    log_out
    visit blog_posting_path(@blog,@posting)
    page.should have_content "You are not authorized to access this page."
  end
  
end