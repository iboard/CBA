Feature: Application
  In order to see the website
  As a guest
  I want to test if there is no error and there is a copyright message
 
  Background:
    Given the following user records
      | id | email               | name         | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 4d2c96042d194751eb000009 | test@test.te | tester     | -1         | verysecret | verysecret            | 1234               | 2001-01-01   |
 
  Scenario: Display a copyright message on the startpage
    Given I am on the home page
    Then I should see "©"
    And I should see "Sign in"
    And I should not see "Error"
    And I should be on the home page
    
  Scenario: Blog News should be displayed on startpage and admins should have a new-posting-button
    Given the following blog records
      | id                       | title    |
      | 4d2c96042d194751eb000001 | News     |
    And the following posting records
      | blog_id                  | user_id                  | title         | body                 |
      | 4d2c96042d194751eb000001 | 4d2c96042d194751eb000009 | Breaking News | Andi won the jackpot |
    And I am on the home page
    Then I should see "Breaking News"
    And I should see "Andi won the jackpot"
    And I should not see "Create new posting"
    Then I am logged in as user "test@test.te" with password "verysecret"
    And I should see "Create new posting"
    
  Scenario: As a guest I should see links to github and pivotal tracker but no create-buttons
    Given I am logged out
    And I am on the home page
    Then I should see "Github"
    And I should see "PivotalTracker"
    And I should not see "Create a new Page"
    And I should not see "Create a new Blog"

  Scenario: As an Admin I should see links to github and pivotal tracker and create-buttons
    Given I am logged in as user "test@test.te" with password "verysecret"
    And I am on the home page
    Then I should see "Github"
    And I should see "PivotalTracker"
    And I should see "Create a new Page"
    And I should see "Create a new Blog"
    
  Scenario: Get latest content as RSS-Feed
  pending
  #  Given I am on the rss feed
  #  Then I should see "TEST WITH RSS FEED"
  #  And I should see "tag:www.example.com"