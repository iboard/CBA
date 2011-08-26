Feature: Blogs
  In order to maintain and read blogs
  As an admin
  I want list, browse, read, and edit blogs

  Background:
    Given the default user set
    And the following blog records
      | title        | allow_comments | allow_public_comments | synopsis                   | is_draft |
      | Blog 1       | true           | true                  | First blog to test         | false    |
      | Blog 2       | true           | true                  | Second blog for testing    | false    |
      | A Blog Draft | true           | true                  | This is a A Blog Draftraft | true     |
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    And draft mode is off

  Scenario: Admin should be able to create a new blog
    Given I am on the blogs page
    And I click on link "Create a new Blog"
    And I fill in "Title" with "Blog 3"
    And I uncheck "blog_is_draft"
    And I click on "Create Blog"
    Then I should be on the blog path of "Blog 3"
    And I should see "successfully created"
    And I should see "Blog 3"
    
  Scenario: Admin creates an unpublished blog
    Given I am on the blogs page
    And I click on link "Create a new Blog"
    And I fill in "Title" with "Blog 3"
    And I check "blog_is_draft"
    And I click on "Create Blog"
    Then I should be on the blog path of "Blog 3"
    And I should see "successfully created"
    And I should see "Blog 3"
  


  Scenario: It should not be able to save a blog with no title
    Given I am on the blogs page
    And I click on link "Create a new Blog"
    And I uncheck "blog_is_draft"
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
      | title    | page_name | page_body         | is_draft |
      | PageBlog | PageOne   | A wonderful body  | false    |
    And I am reading blog of "PageBlog"
    Then I should see "PageOne"
    And I should see "PageBlog"

  Scenario: Blog edit form should show pages to assign
    Given the following blogs with pages
      | title    | page_name | page_body         | is_draft |
      | PageBlog | PageOne   | A wonderful body  | false    |
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
    Given I am reading blog of "Blog 1"
    Then I should see "First blog to test"

  Scenario: Blog show should not display show-button (we are on the show-view already)
    Given I am logged out
    And I am reading blog of "Blog 1"
    Then I should not see "Edit" within ".item_link_buttons"

  Scenario: Blog index shuould display title of blog as link to blog:show
    Given I am on the blogs page
    And I click on link "Blog 1" within "#container_main"
    Then I should be reading "Blog 1"

  Scenario: A blog marked as draft should not be shown on the blogs page
    Given I am logged in as user "user@iboard.cc" with password "thisisnotsecret"
    Given draft mode is off
    And I am on the blogs page
    Then I should not see "A Blog Draft"
    And I should not see "THIS IS A DRAFT"

  Scenario: In draft mode all blogs should be listed
    Given draft mode is off
    And I am on the blogs page
    And I click on link "Show drafts" within "#action_buttons"
    Then I should see "A Blog Draft"
    And I should see "THIS IS A DRAFT"

  Scenario: A blog should not list draft-postings unless draft-mode is on
    Given the following posting records for blog "Blog 1" and user "admin"
      | title         | body            | is_draft |
      | Posting one   | lorem ipsum     | false    |
      | Posting Draft | A Posting Draft | true     |
    And draft mode is off
    And I am reading blog of "Blog 1"
    Then I should not see "Posting Draft"
    Then I click on link "Show drafts" within "#action_buttons"
    Then I should see "Posting Draft"




