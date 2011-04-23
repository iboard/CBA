require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  
  def setup
    User.delete_all
    Invitation.delete_all
  end
  
  def cleanup
    User.delete_all
    Invitation.delete_all
  end
  
  test "Valid invitations should save" do
    user = User.first || Factory.build(:admin)
    invitation = user.invitations.build(:email => 'some@one.at', :name => 'Frank Zappa', :role => 'admin')
    assert invitation.save, "Valid invitation should save"
  end
  
  test "Invalid invitations should not save" do
    user = User.first || Factory.build(:admin)
    invitation = user.invitations.build(:email => 'some_other1@one.at', :name => 'Dweezil Zappa')
    assert invitation.roles_mask == 0, "Default role should be guest"
    
    invitation = user.invitations.build(:email => 'some_other2@one.at', :roles_mask => 4)
    assert !invitation.save, "Invitation should not save w/o name"
    
    invitation = user.invitations.build(:name => 'Moon Zappa', :roles_mask => 4)
    assert !invitation.save, "Invitation should not save w/o email"
  end
  
  test "Invitation should be created by user" do
    User.delete_all
    sponsor = create_valid_user_with_roles_mask('admin')
    sponsor.invitations.create(:email => "hans@email.cc", :name => "Hans Gans", :roles_mask => 4)
    assert sponsor.save, 'Sponsor could not save'
    sponsor.reload
    invitation = sponsor.invitations.first
    assert invitation.email   == "hans@email.cc", 'Email not saved with invitation'
    assert invitation.roles_mask == 4, 'Role not saved with invitation'
  end
  
  test "Invitation should create a random token on create" do
    sponsor = User.first || create_valid_user_with_roles_mask('admin')
    invitation = sponsor.invitations.create(:email => "hans@email.cc", :name => "Hans Gans", :roles_mask => 4)
    assert invitation.token != nil && !invitation.token.blank?, "Token should not be blank or nil"
  end
  
end
