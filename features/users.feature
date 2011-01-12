Feature: User Roles
  In order to maintain users
  As an admin
  I want list all users, edit the user's rolemasks, and I want be able to delete users
  
  #   0 : ----- |   1 : g---- |   2 : -s--- |   3 : gs--- | 
  #   4 : --a-- |   5 : g-a-- |   6 : -sa-- |   7 : gsa-- | 
  #   8 : ---m- |   9 : g--m- |  10 : -s-m- |  11 : gs-m- | 
  #  12 : --am- |  13 : g-am- |  14 : -sam- |  15 : gsam- | 
  #  16 : ----a |  17 : g---a |  18 : -s--a |  19 : gs--a | 
  #  20 : --a-a |  21 : g-a-a |  22 : -sa-a |  23 : gsa-a | 
  #  24 : ---ma |  25 : g--ma |  26 : -s-ma |  27 : gs-ma | 
  #  28 : --ama |  29 : g-ama |  30 : -sama |  31 : gsama | 
  #  (Roles = guest,staff,admin,moderator,author)
  
  
  Background:
    Given the following user records
      | id | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | 4d2c96042d194751eb000001  | admin@iboard.cc  | admin     | 31         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | 4d2c96042d194751eb000002  | user@iboard.cc   | testmax   | 27         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | 4d2c96042d194751eb000003  | guest@iboard.cc  | guest     | 0          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | 4d2c96042d194751eb000004  | staff@iboard.cc  | staff     | 2          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
 
  Scenario: Non-admins and non-staff users should not see the list of users
    Given I sign out
    And I am logged in as user "guest@iboard.cc" with password "thisisnotsecret"
    And I am on users page
    And I should be on the home page
    And I should see "guest"
    And I should not see "testmax"
    And I should not see "admin"
    And I should not see "staff"

  Scenario: Non-admins should not see the edit user page
    Given I sign out
    And I am logged in as user "guest@iboard.cc" with password "thisisnotsecret"
    And I am on edit user page for "user"
    And I should be on the home page
    And I should see "You are not authorized to access this page"

  Scenario: Even staff should not edit user roles
    Given I sign out
    And I am logged in as user "staff@iboard.cc" with password "thisisnotsecret"
    And I am on edit user page for "user"
    And I should be on the home page
    And I should see "You are not authorized to access this page"

  Scenario: Display a list of users when I'm logged in as an admin
    And I am on users page
    Then I should see "admin"
    And I should see "user"

  Scenario: Display a list of users when I'm logged in as a staff member
    Given I sign out
    And I am logged in as user "staff@iboard.cc" with password "thisisnotsecret"
    And I am on users page
    Then I should see "admin"
    And I should see "user"
    And I should see "guest"
    And I should see "staff"

  Scenario: Display the user roles mask when I click 'edit user roles'
    Given I am on users page
    And I click on link "edit_roles"
    Then I should see "Edit User"
    And I should see "Roles"
    And I should see "admin"
  
  Scenario: Remove moderator role from testmax user
    Given I am on edit user page for "user"
    And I uncheck "user_roles_" whithin "role_moderator"
    And I click on "Update"
    Then I should be on the users page
    And I should not see "Moderator" within "td#user_roles_2"
    And I should not see "Admin" within "td#user_roles_2"

  Scenario: Remove all roles from testmax user
      Given I am on edit user page for "user@iboard.cc"
      And I uncheck "user_roles_" whithin "role_guest"
      And I uncheck "user_roles_" whithin "role_staff"
      And I uncheck "user_roles_" whithin "role_admin"
      And I uncheck "user_roles_" whithin "role_moderator"
      And I uncheck "user_roles_" whithin "role_author"
      And I click on "Update"
      Then I should be on the users page
      And I should not see "Guest" within "td#user_roles_2"
      And I should not see "Staff" within "td#user_roles_2"
      And I should not see "Admin" within "td#user_roles_2"
      And I should not see "Moderator" within "td#user_roles_2"
      And I should not see "Author" within "td#user_roles_2"
    
  Scenario: Add all roles to testmax user
      Given I am on edit user page for "user@iboard.cc"
      And I check "user_roles_" whithin "role_guest"
      And I check "user_roles_" whithin "role_staff"
      And I check "user_roles_" whithin "role_admin"
      And I check "user_roles_" whithin "role_moderator"
      And I check "user_roles_" whithin "role_author"
      And I click on "Update"
      Then I should be on the users page
      And I should see "Guest" within "td#user_roles_2"
      And I should see "Staff" within "td#user_roles_2"
      And I should see "Admin" within "td#user_roles_2"
      And I should see "Moderator" within "td#user_roles_2"
      And I should see "Author" within "td#user_roles_2"
