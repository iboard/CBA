Feature: Postings
  In order to post on blogs
  As an user
  I want create, edit, and delete postings
  
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
      | Blog 2 |
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
      
  Scenario: Admin should see the blog listing
    Given I am on the blogs page
    And I should see "Blog 1"
    And I should see "Blog 2"

  Scenario: On a Blog page I want create a new posting
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    Then I should see "Posting successfully created"
    And I should see "My First Posting"
    And I should see "admin, less than a minute ago"
    
  Scenario: "On the Blog page I want delete a posting"
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "Delete" within "#postings"
    Then I should see "Posting successfully destroyed"
    And I should not see "My First Posting"
    
  Scenario: "On the Blog page I want edit a posting"
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "Edit" within "#postings"
    And I fill in "posting_title" with "My First edited Posting"
    And I fill in "posting_body" with "Music is the best"
    And I click on "Update Posting"
    Then I should see "Posting successfully updated"
    And I should see "Music is the best"

  Scenario: "It should not be possible to use the same title twice"
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    Then I should see "already taken"

  Scenario: "There should be a link to edit, delete, and back to the blog when I read a posting"
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I click on link "Blog 1" within "#posting"
    Then I should be on the blog path of "Blog 1"
    And I should see "Edit" within "#postings"
    And I should see "Delete" within "#postings"
    And I click on link "My First Posting"
    And I should see "Edit" within "#posting"
    And I should see "Delete" within "#posting"
    
  Scenario: Pagination should work on postings::index
    pending
   

  