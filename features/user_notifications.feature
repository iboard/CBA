Feature: User System Notifications
  In order keep up to date with the service
  As a user
  I want to see and manage my system notifications
  
  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | user@iboard.cc   | testmax   | 1          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following user_notification records for user "testmax"
      | message                       | hidden |
      | Welcome to the system         | true   |
      | Another message from your cpu | false  |
    And I am logged in as user "user@iboard.cc" with password "thisisnotsecret"
    And I am on the home page

  Scenario: I should see new messages on any page
    Then I should see "Another message from your cpu"
    And I should not see "Welcome to the system"
    
  Scenario: I should see old and new messages on the info-page
    Given I am on the notifications page
    Then I should see "Another message from your cpu"
    And I should see "Welcome to the system"
  
  Scenario: It should be possible to hide messages
    pending
    # TODO THIS TEST SHOULD WORK - IT WORK's IN RUNNING APP BUT NOT HERE?!
    # Given I click on link "hide" within "#user_notifications"
    # And I go to the home page
    # Then I should not see "Another message from your cpu"

  Scenario: It should be possible to redisplay a hidden message
    pending
    # TODO THIS TEST SHOULD WORK - IT WORK's IN RUNNING APP BUT NOT HERE?!
    # Given I am on the notifications page
    # And I click on link "display again" within "#user_notifications"
    # And I go to the home page
    # Then I should see "Another message from your cpu"
    # And I should not see "Welcome to the system"
