Feature: Home
  In order show up stuff on the root page
  As an user
  I want see some elements


  Background:
    Given the following page records
      | title  | body                 | show_in_menu |
      | Page 1 | Lorem ipsum          | true         |
      | Page 2 | Lirum Opsim          | false        |

  Scenario: The home-page should show top pages in a sidebar
     Given I am on the home page
     Then I should see "Page 1"
     And I should see "Lorem ipsum"
     And I should not see "Lirum Opsim"

  Scenario: If twitter.html exist the home page should show the twitter-box
     Given the following file
       | filename                 | content                 |
       | config/twitter.test.html | This is the twitter box |
     And I am on the home page
     Then I should see "This is the twitter box"
