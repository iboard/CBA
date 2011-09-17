Feature: Home
  In order show up stuff on the root page
  As an user
  I want see some elements


  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 31         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following page records
      | title          | body                 | show_in_menu |
      | A Twitter page | Lorem Twittum        | true         |

  Scenario: The home-page should show top pages in a sidebar
     Given I am on the home page
     Then I should see "A Twitter page"
     And I should see "Lorem Twittum"

  Scenario: If twitter.html exist the home page should show the twitter-box
     Given the following file
       | filename                 | content                 |
       | config/twitter.test.html | This is the twitter box |
     And I am on the home page
     Then I should see "This is the twitter box"
     Then delete file "config/twitter.test.html"

  Scenario: Link Show drafts should be displayed if draft mode is off
     Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
     And I am on the home page
     And draft mode is off
     Then I should see "Show drafts"
     
  Scenario: Link Hide drafts should be displayed if draft mode is on
     Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
     And I am on the home page
     And draft mode is on
     Then I should see "Hide drafts"     
     
  Scenario: Get empty RSS-Feed
    Given I am on the rss feed
    Then I should see "TESTFEED"
    And I should see "A Twitter page"
    And I should see "Lorem Twittum"
    
  Scenario: BUGFIX: do not concat to view for builder
    Given the following blogs with pages
      | title    | page_name | page_body                  | is_draft |
      | PageBlog | PageOne   | A wonderful body           | false    |
      | PageBlog | PageTwo   | This page should be there  | false    |
    And the following posting records for blog "PageBlog" and user "admin"
      | title         | body                                  | is_draft |
      | Posting one   | lorem ipsum with <p>some<br></p> html | false    |
      | Posting Draft | A Posting Draft | true     |
    And I am on the rss feed
    Then I should see a valid rss-feed containing "&lt;p&gt;lorem ipsum with some html&lt;p&gt;"
    
  Scenario: RSS-Feed should not show drafts
    Given the following blogs with pages
      | title    | page_name | page_body                      | is_draft |
      | PageBlog | PageOne   | A wonderful body               | false    |
      | PageBlog | PageTwo   | This page should not be there  | true    |
    And the following posting records for blog "PageBlog" and user "admin"
      | title         | body                                  | is_draft |
      | Posting one   | Should be shown                       | false    |
      | Posting Draft | A Posting Draft                       | true     |
    And I am on the rss feed
    Then I should not see "This page should not be there"
    And I should not see "A Posting Draft"
    And I should see "Should be shown"
    And I should see "A wonderful body"
    
  Scenario: BUGFIX: unpriviledged users should not see draft postings on root path
    Given the following blog records
      | title | is_draft |
      | News  | false    |
    Given the following posting records for blog "News" and user "admin"
      | title      | body                                           | is_draft |
      | Direct Post| The posting should load the blog it belongs to | false    |
      | Draft Post | This should not be visible to non-authors      | true     |
    And I am logged out
    And I am on the home page
    Then I should see "Direct Post"
    And I should not see "Draft Post"
    And I should not see "This should not be visible to non-authors"

