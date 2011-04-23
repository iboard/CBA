Feature: Invitation
  In order to invite other users to the system
  As a user or maintainer
  I want to send invitation
 
  Background:
    Given the following user records
      | id                       | email           | name       | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 4d2c96042d194751eb000009 | sponsor@test.te | maintainer | -1         | verysecret | verysecret            | 1234               | 2001-01-01   |
 
  Scenario: User Profile Mask should have an invite-link
    Given I am logged in as user "sponsor@test.te" with password "verysecret"
    And I am on the profile page of user "maintainer"
    Then I should see "Send invitation"
