Feature: Blogs
  In order to maintain and read blogs
  As an admin
  I want list, browse, read, and edit blogs

  Background:
    Given the default user set
    And the following blog records
      | title  | allow_comments | allow_public_comments | synopsis                |
      | Blog 1 | true           | true                  | First blog to test      |
      | Blog 2 | true           | true                  | Second blog for testing |
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
    And I should see "can't be blank"

  Scenario: Admin should be able to delete a blog
    Given I am on the blogs page
    And I click on link "Delete"
    Then I should be on the blogs page
    And I should not see "Blog 1"

  Scenario: A blog should render assigned pages
    Given the following blogs with pages
      | title    | page_name | page_body         |
      | PageBlog | PageOne   | A wonderful body  |
    And I am in the blog page of "PageBlog"
    Then I should see "PageOne"
    And I should see "PageBlog"

  Scenario: Blog edit form should show pages to assign
    Given the following blogs with pages
      | title    | page_name | page_body         |
      | PageBlog | PageOne   | A wonderful body  |
    And I am on the blog path of "PageBlog"
    And I click on link "Edit" within "#page_blog"
    Then I should see "Pages shown on side bar"
    And I should see "PageOne"

  Scenario: Blog index should show summary
    Given I am on the blogs page
    Then I should see "No postings yet"
    And I should see "Authenticated comments: allowed"
    And I should see "Anonymous comments: allowed"
    And I should see "First blog to test"
    And I should see "Second blog for testing"

  Scenario: Blog show should display synopsis
    Given I am in the blog page of "Blog 1"
    Then I should see "First blog to test"

  Scenario: Blog show should not display show-button (we are on the show-view already)
    Given I am in the blog page of "Blog 1"
    Then I should not see "Edit" within ".item_link_buttons"
