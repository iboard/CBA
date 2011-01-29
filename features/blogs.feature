@focus
Feature: Blogs
  In order to maintain and read blogs
  As an user
  I want list, browse, read, and edit blogs
  
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
 
     
  Scenario: Admin should be able to create a new blog
    Given I am on the blogs page
    And I click on link "Create a new Blog"
    And I fill in "Title" with "Blog 3"
    And I click on "Create Blog"
    Then I should be on the blog path of "Blog 3"
    And I should see "successfully created"
    And I should see "Blog 3"
    
  Scenario: It should not be able to save a blog with no title
    Given I am on the blogs page
    And I click on link "Create a new Blog"
    And I click on "Create Blog"
    Then I should see "Create a new Blog" within "#container"
    And I should see "Title can't be blank"

  Scenario: Admin should be able to delete a blog
    Given I am on the blogs page
    And I click on link "Delete"
    Then I should be on the blogs page
    And I should not see "Blog 1"
