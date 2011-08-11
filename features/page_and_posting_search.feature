@focus
@fokus
Feature: Search
  In order Search for posts and pages
  As a user
  I want enter a search term and find postings and pages

  Background:
    Given the default user set
    And I am logged out
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    And I have a clean database
    And draft mode is off
    And the following blog records
      | title  | is_draft |
      | News   | false    |
    And the following posting records for blog "News" and user "admin"
      | title      | body                                           | is_draft |
      | Direct Post| The posting should load the blog it belongs to | false    |
      | Hotzenplotz| This is some text I wanna search for lorem     | false    |
      | Your Title | This is another text I proberly wanna search   | false    |
    And only the following page records
      | title    | body                 | show_in_menu | is_draft    | is_template |
      | Page A   | Lorem ipsum          | true         | false       | false    |
      | Page B   | Lirum Opsim          | true         | false       | false    |
      | Testpage | Rails Rulez Lorem    | true         | false       | false    |

@focus_todo
  Scenario: The homepage should have a searchbox for pages
    Given I am on the home page
    And I fill in "searchfield" with "Rails"
    Then I click on "Search"
    And I should see "Testpage"
    And I should see "Rails Rulez"
    And I should not see "The posting should load the blog it belongs to"

@focus_todo
  Scenario: The homepage should have a searchbox for pages and postings
    Given I am on the home page
    And I fill in "searchfield" with "Lorem"
    Then I click on "Search"
    And I should see "Testpage"
    And I should see "Rails Rulez"
    And I should see "Hotzenplotz"
    And I should not see "The posting should load the blog it belongs to"

  Scenario: The homepage should have a searchbox for postings
    Given I am on the home page
    And I fill in "searchfield" with "Hotzenplotz"
    And I click on "Search"
    Then I should see "Hotzenplotz"
    And I should see "This is some text I wanna search for"
    And I should not see "This is another text I proberly wanna search"
