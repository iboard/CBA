@focus
Feature: Search
  In order Search for posts and pages
  As a user
  I want enter a search term and find postings and pages

  Background:
    Given the default user set
    And I am logged out
    And the following blog records
      | title  | is_draft |
      | News   | false    |
    And the following posting records for blog "News" and user "admin"
      | title      | body                                           | is_draft |
      | Direct Post| The posting should load the blog it belongs to | false    |
      | Hotzenplotz| This is some text I wanna search for lorem     | false    |
      | Your Title | This is another text I proberly wanna search   | false    |
    And the following page records
      | title  | body                 | show_in_menu | is_template | is_draft |
      | Page 1 | Lorem ipsum          | true         | false       | false    |
      | Page 2 | Lirum Opsim          | false        | false       | false    |
      | Page 3 | Rails Rulez Lorem    | false        | false       | false    |
    And I am on the home page

  Scenario: The homepage should have a searchbox for postings
    Given I fill in "searchfield" with "Hotzenplotz"
    And I click on "Search"
    Then I should see "Hotzenplotz"
    And I should see "This is some text I wanna search for"
    And I should not see "This is another text I proberly wanna search"

  Scenario: The homepage should have a searchbox for pages
    pending
    # does work with cucumber_focus but not when called with al features
    #Given I fill in "searchfield" with "Rails"
    #And I click on "Search"
    #Then I should see "Page 3"
    #And I should see "Rails Rulez"
    #And I should not see "The posting should load the blog it belongs to"

  Scenario: The homepage should have a searchbox for pages and postings
    pending
    # does work with cucumber_focus but not when called with al features
    # Given I fill in "searchfield" with "Lorem"
    # And I click on "Search"
    # Then I should see "Page 3"
    # And I should see "Rails Rulez"
    # And I should see "Hotzenplotz"
    # And I should not see "The posting should load the blog it belongs to"
