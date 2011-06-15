Feature: SiteMenus
  In order to navigate pages
  As a user
  I want see a sidebar with a submenu

  Background:
    Given the following user records
      | email            | name      | roles_mask | password         | password_confirmation | confirmed_at         |
      | admin@iboard.cc  | admin     | 6         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
      | user@iboard.cc   | testmax   | 2         | thisisnotsecret  | thisisnotsecret       | 2010-01-01 00:00:00  |
    And the following page records
      | title  | body                 | show_in_menu |
      | Page 1 | Lorem ipsum          | false        |
      | Page 2 | Lirum Opsim          | false        |
    And the following site_menu
      | name              | target       |
      | rootA             | /            |
      | rootA.item1       | /help_fake   |
      | rootA.item2       | /help_fake/1 |
      | rootB             | /pages       |
      | rootB.Blorem      | /p/page_1    |
      | rootB.Blirum      | /p/page_2    |
      | rootB.Blirum.Sub1 | /dummy1      |
      | rootB.Blirum.Sub2 | /dummy2      |

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