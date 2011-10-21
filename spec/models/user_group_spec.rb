require 'spec_helper'

describe "User-group" do

  before(:all) do
    cleanup_database
    create_default_userset
    @friends = [ 
                 User.where(email: 'user@iboard.cc').first.id,
                 User.where(email: 'maintainer@iboard.cc').first.id
               ]    
  end
  
  it "should be embedded in user" do
    user = User.first
    user.user_groups.create name: 'Friends', members: @friends
    user.save!
    user.reload
    assert user.user_groups.first.members == @friends, "#{@friends.inspect} != #{user.user_groups.first.members.inspect}"
  end
  
  it "should store users given by user_tokens" do
    user = User.first
    friends = User.first.user_groups.find_or_create_by( name: 'Friends' )
    friends.member_tokens = @friends.map{|id| id.to_s}.join(",")
    user.save!
    user.reload
    assert user.user_groups.first.members == @friends, "#{@friends.inspect} != #{user.user_groups.first.members.inspect}"
  end
  
  it "should provide member names as string" do
    user = User.first
    friends = User.first.user_groups.find_or_create_by( name: 'Friends' )
    friends.member_tokens = @friends.map{|id| id.to_s}.join(",")
    user.save!
    user.reload
    assert user.user_groups.first.member_names == "testmax, maintainer", "Should return 'testmax, maintainer'"
  end
  

end
