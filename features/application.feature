Feature: Application
  In order to see the website
  As a guest
  I want to test if there is no error and there is a copyright message
 
  Background:
    Given the following user records
      | id | email            | name      | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 4d2c96042d194751eb000009  | test@test.te     | tester    | -1         | verysecret | verysecret            | 1234               | 2001-01-01   |
 
  Scenario: Display a copyright message on the startpage
    Given I am on the home page
    Then I should see "©"
    And I should see "Sign in"
    And I should not see "Error"
    And I should be on the home page


  Scenario: Get latest content as RSS-Feed
  pending
  #  Given I am on the rss feed
  #  Then I should see "TEST WITH RSS FEED"
  #  And I should see "tag:www.example.com"