Feature: Pages
  In order to maintain and read pages
  As an user
  I want list, browse, read, and edit pages
  
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
 
  Scenario: Pages with 'show_in_menu' should be on the menu-bar
    Given I am on the pages page
    Then I should see "Page 1" within ".hmenu"
    And I should not see "Page 2" within ".hmenu"
    
  Scenario: A page should be shown when clicking read from the index
    Given I am on the pages page
    And I click on link "Read"
    Then I should be on the permalink_path of "Page 1"
    And I should see "Page 1"
    And I should see "Lorem ipsum"

  Scenario: Admin should be able to delete a page
    Given I am on the pages page
    And I click on link "Delete"
    Then I should be on the pages page
    And I should not see "Page 1"
    
  Scenario: Admin should be able to create a new page and this page should be rendered with textile
    Given I am on the pages page
    And I click on link "Create a new Page"
    And I fill in "Title" with "Page 3"
    And I fill in "Body" with "h1. Page three body"
    And I click on "Create Page"
    Then I should be on the page path of "Page 3"
    And I should see "successfully created"
    And I should see "Page 3"
    And I should see "Page three body" within "#container"
    And I should see "Page 3" within ".hmenu"
    
  Scenario: It should not be able to save a page with no title
    Given I am on the pages page
    And I click on link "Create a new Page"
    And I fill in "Body" with "h1. Page three body"
    And I click on "Create Page"
    Then I should see "Create a new Page" within "#container"
    And I should see "Title can't be blank"
    
  Scenario: It should not be able to save a page without a body
    Given I am on the pages page
    And I click on link "Create a new Page"
    And I fill in "Title" with "Page three body"
    And I click on "Create Page"
    Then I should see "Create a new Page" within "#container"
    And I should see "Body can't be blank"
