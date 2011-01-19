Feature: Comments on pages
  In order comment pages
  As an user
  I want see, add, edit, and remove (in a short period of time after creating) comments.
  
  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 31         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | user@iboard.cc   | testmax   | 27         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | guest@iboard.cc  | guest     | 0          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | staff@iboard.cc  | staff     | 2          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following page records
      | title  | body                 | show_in_menu |
      | Page 1 | Lorem ipsum          | true         |
      | Page 2 | Lirum Opsim          | false        |
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
 
  Scenario: When showing a page, there should be an 'Add-Comment-Button'
    Given I am on the page path of "Page 1"
    Then I should see "Post a comment"
    
  Scenario: When I fill in a comment and press commit I should see my comment
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "One comment"
    And I should see "Frank Zappa wrote, less than a minute ago"
    And I should see "Lorem Commentum gscheit daherred"
    
  Scenario: Comments without a name should not be saved
    Given I am on the page path of "Page 1"
    And I fill in "Name" with ""
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "No comment yet"
    And I should see "Comment could not be saved!"
    
  Scenario: Comments without an email should not be saved
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with ""
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "No comment yet"
    And I should see "Comment could not be saved!"

  Scenario: Comments without a comment should not be saved
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "frank@zappa.com"
    And I fill in "Comment" with ""
    And I click on "Post comment"
    Then I should see "No comment yet"
    And I should see "Comment could not be saved!"

@focus
  Scenario: As an admin I should be able to destroy a comment
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    And I click on "Edit"
    Then show me the page
  