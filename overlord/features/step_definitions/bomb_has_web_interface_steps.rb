Feature: The bomb interface runs on a webserver
  In order to access the bomb from anywhere
  As a supervillain
  I should be able to use a web browser to view the bomb interface

  Scenario: Viewing bomb interface
    Given a bomb
    When I visit the page
    Then I should see the bomb's status
    And I should see a field to enter the activation/deactivation code
    And I should see a submit button with which to submit the activation/deactivation code
    And I should see a timer displaying a countdown to explosion
