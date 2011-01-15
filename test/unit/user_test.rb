require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "A just built new user sould not save" do
    user = User.new
    assert !user.save, "Saved new user without setting the object up for usage"
  end
  
  test "A user with email, name should not save without a password" do
    user = User.new(:email => 'tester@test.te', :name => 'Nockenfell')
    assert !user.save, "User saved without a password"
  end
  
  test "A user with email and password should not save without a name" do
    user = User.new(:email => 'tester@test.te', :password => 'secret', :password_confirmation => 'secret')
    assert !user.save, "User saved without a name"
  end
  
  test "A user should save with email, name, and password" do
    user = create_valid_user_with_id(1)
    assert user.save, "User not saved with email, name, and password"
  end
  
  test "A user should not save with wrong password-confirmation" do
    user = User.new(:email => 'tester@test.te', :password => 'secret', :password_confirmation => 'secred', :name => 'nockenfell')
    assert !user.save, "User saved with wrong password-confirmation"
  end
  
  test "A user should not save with invalid email-address" do
    user = User.new(:email => 'tester-at-test.te', :password => 'secret', :password_confirmation => 'secret', :name => 'nockenfell')
    assert !user.save, "User saved with invalid email"
  end
end
