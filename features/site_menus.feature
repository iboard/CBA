Feature: SiteMenus
  In order to navigate pages
  As a user
  I want see a sidebar with a submenu

  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 6          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | user@iboard.cc   | testmax   | 2          | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following page records
      | title  | body                 | show_in_menu |
      | Page 1 | Lorem ipsum          | false        |
      | Page 2 | Lirum Opsim          | false        |
    And the following site_menu
      | name              | site_menu_target |
      | rootA             | /                |
      | rootA.item1       | /help_fake       |
      | rootA.item2       | /help_fake/1     |
      | rootB             | /pages           |
      | rootB.Blorem      | /p/page_1        |
      | rootB.Blirum      | /p/page_2        |
      | rootB.Blirum.Sub1 | /dummy1          |
      | rootB.Blirum.Sub2 | /dummy2          |

  Scenario: I wanna see a sumbenue on the homepage
    Given I am on the home page
    Then I should see "rootA"
    And I should see "item1"
    And I should see "item2"
    And I should see "rootB"
    When I click on link "rootB"
    Then I should see "rootB"
    And I should see "Blorem"
    And I should see "Blirum"
    Then I click on link "Blirum"
    Then I should see "Sub1"
    And I should see "Sub2"

  Scenario: Admin should have a link to edit site-menues before there is a site-menu
    Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    Then I should see "Menus" within "#action_buttons"

  Scenario: Non-Admins should not see the Menu-Action-Buttons
    Given I am logged out
    And I am on the home page
    Then I should not see "Menus" within "#action_buttons"

  Scenario: Admin should be able to list SiteMenus
    Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    And I am on the home page
    And I click on link "Menus" within "#action_buttons"
    Then I should be on the site_menus page
    And I should see "Manage Site Menus"

  Scenario: Admin should be able to edit a menu entry
    Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    And I am on the site_menus page
    And I click on link "Edit" within ".site_menu_manage_buttons"
    Then I should be on the edit site_menu page for menu "rootA"
    And I fill in "Name" with "ROOT-A"
    And I click on "Update Site menu"
    Then I should be on the site_menus page
    And I should see "ROOT-A"

  Scenario: Admin should be able to delete a menu entry
    Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    And I am on the site_menus page
    And I click on link "Delete" within ".site_menu_manage_buttons"
    Then I should be on the site_menus page
    And I should not see "rootA"

  Scenario: Admin should be able to add a new site_menu
    Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    And I am on the site_menus page
    And I click on link "Add New Menu" within "#container"
    Then I should be on the new site_menu page
    And I should see "New menu entry"

  Scenario: Admin should be able to add a submenu item
    Given I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
    And I am on the site_menus page
    And I click on link "Add submenu" within "#container"
    Then I should be on the new site_menu page
    And I should see "New submenu for rootA"
    And I fill in "Name" with "Submenu"
    And I fill in "site_menu[site_menu_target]" with "/submenu_path"
    And I click on "Create Site menu"
    Then I should be on the site_menus page
    And I should see "/submenu_path"





