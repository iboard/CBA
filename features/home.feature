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
     
  Scenario: Get latest content as RSS-Feed
    Given I am on the rss feed
    Then I should see "TESTFEED"
    And I should see "A Twitter page"
    And I should see "Lorem Twittum"
