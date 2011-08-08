Feature: Postings
  In order to post on blogs
  As an user
  I want create, edit, delete, and comment postings

  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 31         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | user@iboard.cc   | testmax   | 27         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | guest@iboard.cc  | guest     | 0          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | staff@iboard.cc  | staff     | 2          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following blog records
      | title  | is_draft |
      | Blog 1 | false    |
      | Blog 2 | false    |
      | News   | false    |
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
    And I uncheck "posting_is_draft"
    And I click on "Create Posting"
    Then I should see "Posting successfully created"
    And I should see "My First Posting"
    And I should see "admin, less than a minute ago"

  Scenario: On the Blog page I want delete a posting
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I uncheck "posting_is_draft"
    And I click on "Create Posting"
    And I click on link "Delete" within "#postings"
    Then I should see "Posting successfully destroyed"
    And I should not see "My First Posting"

  Scenario: On the Blog page I want edit a posting
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I uncheck "posting_is_draft"
    And I click on "Create Posting"
    And I click on link "Edit" within "#postings"
    And I fill in "posting_title" with "My First edited Posting"
    And I fill in "posting_body" with "Music is the best"
    And I click on "Update Posting"
    Then I should see "Posting successfully updated"
    And I should see "Music is the best"

  Scenario: It should not be possible to use the same title twice
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I uncheck "posting_is_draft"
    And I click on "Create Posting"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I click on "Create Posting"
    Then I should see "already taken"

  Scenario: There should be a link to edit, delete, and back to the blog when I read a posting
    Given I am on the blog path of "Blog 1"
    And I click on link "Create new posting" within "#container"
    And I fill in "posting_title" with "My First Posting"
    And I fill in "posting_body" with "Lorem ipsum Postingum"
    And I uncheck "posting_is_draft"
    And I click on "Create Posting"
    And I click on link "My First Posting"
    And I click on link "Blog 1" within "#posting"
    Then I should be on the blog path of "Blog 1"
    And I should see "Edit" within "#postings"
    And I should see "Delete" within "#postings"
    And I click on link "My First Posting"
    And I should see "Edit" within "#posting"
    And I should see "Delete" within "#posting"

  Scenario: A Posting should be commentable
    Given the following posting records for blog "Blog 1" and user "admin"
      | title       | body        | is_draft |
      | Posting one | lorem ipsum | false    |
    And I am on the blog path of "Blog 1"
    And I click on link "Posting one"
    And I fill in "Comment" with "And here my comment"
    And I click on "Post comment"
    Then I should be on the read posting "Posting one" page of blog "Blog 1"
    And I should see "Comment successfully created. You can edit it for the next"
    And I should see "And here my comment"

  Scenario: Pagination should work on postings::index
    pending

  Scenario: A posting should be routed without nesting in blog
    Given the following posting records for blog "Blog 1" and user "admin"
      | title      | body                                           | is_draft |
      | Direct Post| The posting should load the blog it belongs to | false    |
    And I am on the posting page of "Direct Post"
    Then I should see "The posting should load the blog it belongs to"
    And I should see "in Blog 1"

  Scenario: Postings should be provided as atom-feed
    Given the following posting records for blog "Blog 1" and user "admin"
      | title      | body                                           | is_draft |
      | Direct Post| The posting should load the blog it belongs to | false    |
    And I am on the feed page
    Then I should see "Direct Post"
    And I should see "The posting should load the blog it belongs to"

  Scenario: The homepage should have a searchbox for postings
    Given the following posting records for blog "News" and user "admin"
      | title      | body                                           | is_draft |
      | Direct Post| The posting should load the blog it belongs to | false    |
      | Hotzenplotz| This is some text I wanna search for           | false    |
      | Your Title | This is another text I proberly wanna search   | false    |
    And I am on the home page
    And I fill in "search" with "Hotzenplotz"
    And I click on "Search"
    Then I should see "Hotzenplotz"
    And I should see "This is some text I wanna search for"
    And I should not see "This is another text I proberly wanna search"
  