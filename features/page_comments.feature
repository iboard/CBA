Feature: Comments on pages
  In order comment pages
  As an user
  I want see, add, edit, and remove (in a short period of time after creating) comments.
  
  Background:
    Given the default user set
    And the following default pages
      | title  | body                 | show_in_menu | allow_public_comments | allow_comments |
      | Page 1 | Lorem ipsum          | true         | true                  | true           |
      | Page 2 | Lirum Opsim          | false        | true                  | true           |
    And I am logged in as user "admin@iboard.cc" with password "thisisnotsecret"
 
  Scenario: When showing a page, there should be an 'Add-Comment-Button'
    Given I am on the page path of "Page 1"
    Then show me the page
    Then I should see "Post a comment"
    
  Scenario: When I fill in a comment and press commit I should see my comment
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "One comment"
    And I should see "Frank Zappa, less than a minute ago"
    And I should see "Lorem Commentum gscheit daherred"
    
  Scenario: Comments without a name should not be saved
    Given I am on the page path of "Page 1"
    And I fill in "Name" with ""
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should not see "Lorem Commentum gscheit daherred"
    And I should see "Comment could not be saved!"
    
  Scenario: Comments without an email should not be saved
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with ""
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should not see "Lorem Commentum gscheit daherred"
    And I should see "Comment could not be saved!"

  Scenario: Comments without a comment should not be saved
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "frank@zappa.com"
    And I fill in "Comment" with ""
    And I click on "Post comment"
    Then I should not see "Frank Zapp"
    And I should see "Comment could not be saved!"

  Scenario: As an admin I should be able to edit a comment
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    And I click on link "Edit" within "#comments"
    And I fill in "comment[comment]" with "Modified music is modified best"
    And I click on "Post comment"
    Then I should see "Modified music is modified best" within "#comments"

  Scenario: As an admin I should be able to destroy a comment
    Given I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    And I click on link "Delete" within "#comments"
    Then I should not see "Lorem Commentum gscheit daherred"
    And I should see "Comment successfully deleted"
    
  Scenario: A new posting should be editable for n minutes after creating it
    Given I am logged out
    And I am on the page path of "Page 1"
    And I fill in "Name" with "Frank Zappa"
    And I fill in "Email" with "some@address.at"
    And I fill in "Comment" with "Lorem Commentum gscheit daherred"
    And I click on "Post comment"
    Then I should see "Edit (for"
    And I click on link "Edit" within "#comments"
    And I fill in "Comment" with "Modified music is modified best"
    And I click on "Post comment"
    Then I should see "Modified music is modified best" within "#comments"
    And I should see "Edit (for"
  
  
  