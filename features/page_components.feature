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
    And the following page_template records
      | name    | html_template                              |
      | default | TITLE BODY COMMENTS ATTACHMENTS COMPONENTS |
    And the following page records
      | title  | body                 | show_in_menu | is_draft | is_template | interpreter |
      | Page 1 | This is page one     | false        | false    | false       | :markdown   |
      | Page 2 | This is page two     | false        | false    | false       | :markdown   |
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


  Scenario: Page components should have input fields for translations
    Given the following translated components for page "Page 1"
       | title_en   | body_en      | title_de | body_de   |
       | GB         | Fish n chips | Austria  | Schnitzel |
    And I am on the page path of "Page 1"
    And I click on link "Edit"
    Then I should see "Body (de)" within "#components"

  Scenario: Page components should be translated
    Given the following translated components for page "Page 1"
       | title_en   | body_en      | title_de | body_de   |
       | GB         | Fish n chips | Austria  | Schnitzel |
    And I am on the page path of "Page 1"
    Then I should see "Fish n chips"
    Then I click on link "locale_de"
    Then I should see "Schnitzel"
    Then I click on link "locale_en"
    Then I should see "Fish n chips"
    Then the default locale

  Scenario: A page component should be editable while viewing the page
    Given the following translated components for page "Page 2"
      | title_en   | body_en      | title_de | body_de      |
      | C1         | Component 1  | K1       | Komponente 1 |
    And I am on the page path of "Page 2"
    Then show me the page
    And I click on link "Edit" within ".page-component"
    Then I should be on the edit first component path for "Page 2"
    And I fill in "page_component_body" with "Page 2 component 1 modified"
    And I click on "Update component"
    Then I should be on the page path of "Page 2"
    And I should see "Page 2 component 1 modified"
    And I should see "Page component successfully updated"
