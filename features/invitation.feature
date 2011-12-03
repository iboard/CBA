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
    Then I should have_link "Invite user"

  Scenario: User should see invitation form
    Given I am logged in as user "sponsor@test.te" with password "verysecret"
    And I am on the profile page of user "maintainer"
    And I click on link "Send invitation"
    Then I should see "Invite user"
    And I should see "Submit"
    
  Scenario: User should be able to send an invitation
    Given I am logged in as user "sponsor@test.te" with password "verysecret"
    And I am on the profile page of user "maintainer"
    And I click on link "Send invitation"
    And I fill in "invitation_name" with "Dear Friend"
    And I fill in "invitation_email" with "friend@test.te"
    And I click on "Send invitation"
    Then I should be on the profile page of user "maintainer"
    And I should see "Your invitation was sent to"
    
  Scenario: User should not send empty invitations
    Given I am logged in as user "sponsor@test.te" with password "verysecret"
    And I am on the profile page of user "maintainer"
    And I click on link "Send invitation"
    And I click on "Send invitation"
    Then I should see "3 errors: Invitation can not be saved"
    And I should see "Name: can't be blank"
    And I should see "Email: can't be blank"

  Scenario: Email of invitee should be format-validated
    Given I am logged in as user "sponsor@test.te" with password "verysecret"
    And I am on the profile page of user "maintainer"
    And I click on link "Send invitation"
    And I fill in "invitation_name" with "Dear Friend"
    And I fill in "invitation_email" with "ThisIs not an email!"
    And I click on "Send invitation"
    Then I should see "One error: Invitation can not be saved"
    And I should see "Email: Is not an email address"
