Feature: User Roles
  In order to maintain users
  As an admin
  I want list all users, edit the user's rolemasks, and I want be able to delete users
  
#  ROLES = [:guest, :confirmed_user, :author, :moderator, :maintainer, :admin]
#             0         1               2        3            4           5
  
  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | user@iboard.cc   | testmax   | 1          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | guest@iboard.cc  | guest     | 0          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | staff@iboard.cc  | staff     | 4          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | admin@iboard.cc  | admin     | 5          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
 
  Scenario: Non-admins and non-staff users should not see the list of users
    Given I sign out
    And I am logged in as user "guest@iboard.cc" with password "thisisnotsecret"
    And I am on users page
    And I should see "guest"
    And I should not see "testmax"
    And I should not see "admin"
    And I should not see "staff"

  Scenario: Display a list of users when I'm logged in as an admin
    Given I am on registrations page
    Then I should see "admin"
    And I should see "staff"
    And I should see "testmax"
    And I should see "guest"

  Scenario: Non-admins should not see the edit user page of foreign users
    Given I sign out
    And I am logged in as user "guest@iboard.cc" with password "thisisnotsecret"
    And I am on edit role page for "testmax"
    Then I should not see "testmax"

  Scenario: Display the user roles mask when I click 'edit user roles'
    Given I am on registrations page
    And I click on link "Detail"
    And I click on link "Edit role"
    Then I should see "Edit role of user "
    And I should see "testmax"
    And I should see "Role"

  Scenario: Remove confirmed user role from testmax
    Given I am on edit role page for "testmax"
    And I select "Guest" from "user_roles_mask"
    And I click on "Update User"
    Then I should be on the registrations page
    And I should see "Guest" within "#user_roles_testmax"
    And I should see "testmax"
    And I should see "successfully updated"
    And I should not see "Moderator" within "#user_roles_testmax"
    
  Scenario: Add all roles to testmax user
    Given I am on edit role page for "testmax"
    And I select "Admin" from "user_roles_mask"
    And I click on "Update User"
    Then I should be on the registrations page
    And I should see "Admin" within "#user_roles_testmax"
    And I should see "testmax"
    And I should see "successfully updated"
    And I should not see "Guest" within "#user_roles_testmax"

  Scenario: Admin should be able to cancel any account
    Given I am on registrations page
    And I click on link "Cancel this account"
    Then I should be on registrations page
    And I should see "User successfully deleted"
    And I should not see "testmax"
  