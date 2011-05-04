Feature: PageComponents
  In order to render more complex pages
  As an user
  I want maintain components of pages

  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 5          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | author@iboard.cc | author    | 4          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | guest@iboard.cc  | guest     | 0          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following page records
      | title  | body                 | show_in_menu |
      | Page 1 | Test Page            | false        |
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"

  Scenario: Edit page form should offer 'add component' button
    Given I am on the edit page for "Page 1"
    Then I should see "Add new page component"

  Scenario: Clicking Add Component should show New Component form
    pending
    #TODO: This feature works with js only. Add jasmin or any other js-testing-framework
    #TODO: to test this feature
    #  Given I am on the edit page for "Page 1"
    #  And I click on link 'Add component'
    #  Then I should be on the add component page for page "Page 1"
    #  And I should see "Add new component to page 'Page 1'"
    
  Scenario: A Page using PageTemplate should render PLACEHOLDERS in body
    pending
    
