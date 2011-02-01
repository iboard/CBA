Feature: Comments on postings
  In order comment postings
  As an user
  I want see, add, edit, and remove (in a short period of time after creating) comments.
  
  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 31         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | user@iboard.cc   | testmax   | 27         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | guest@iboard.cc  | guest     | 0          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | staff@iboard.cc  | staff     | 2          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following blog records
      | title  | 
      | Blog 1 | 
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
 
  Scenario: When showing a posting, there should be an 'Add-Comment-Button'
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    Then I should see "Post a comment"
    
  Scenario: When I fill in a comment and press commit I should see my comment
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "One comment"
    And I should see "Frank Zappa, less than a minute ago"
    And I should see "Lorem Commentum gscheit daherred"
    
  Scenario: Comments without a name should not be saved
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I fill in "Name" with ""
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "No comment yet"
    And I should see "Comment could not be saved!"
    
  Scenario: Comments without an email should not be saved
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with ""
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "No comment yet"
    And I should see "Comment could not be saved!"

  Scenario: Comments without a comment should not be saved
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I click on "Post comment"
    Then I should see "No comment yet"
    And I should see "Comment could not be saved!"

  Scenario: As an admin I should be able to edit a comment
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    And I click on link "Edit" within "#comments"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Music is the best"
    And I click on "Post comment"
    And I click on link "Edit" within "#comments"
    And I fill in "comment[comment]" with "Modified music is modified best"
    And I click on "Post comment"
    Then I should see "Modified music is modified best" within "#comments"

  Scenario: As an admin I should be able to destroy a comment
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    And I click on link "Delete" within "#comments"
    Then I should not see "Lorem Commentum gscheit daherred" within "#comments"
    And I should see "Comment successfully deleted"
