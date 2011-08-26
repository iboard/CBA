Feature: PageTemplates
  In order to manage page templates
  As an admin
  I want CRUD PageTemplates

  Background:
    Given the default user set
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"

  Scenario: There should be a link to templates within action buttons
    Given I am on the home page
    Then I should see "Templates" within "#action_buttons"

  Scenario: I should see the Template index when clicking 'Templates'
    Given I am on the home page
    And I click on link "Templates" within "#action_buttons"
    Then I should be on the templates page

