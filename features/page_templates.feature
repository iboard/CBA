Feature: PageTemplates
  In order to manage page templates
  As an admin
  I want CRUD PageTemplates

  Background:
    Given the following user records
      | id                       | email         | name  | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 4d2c96042d194751eb000009 | admin@test.te | admin | 5          | verysecret | verysecret            | 1234               | 2001-01-01   |
    And I am logged in as user "admin@test.te" with password "verysecret"

  Scenario: There should be a link to templates within action buttons
    Given I am on the home page
    Then I should see "Templates" within "#action_buttons"

  Scenario: I should see the Template index when clicking 'Templates'
    Given I am on the home page
    And I click on link "Templates" within "#action_buttons"
    Then I should be on the templates_pages page
