Feature: The user sees a different image based on the bomb's status
  In order to see the bomb's current state
  As a supervillain
  I should be able to change the bomb's state via activation/deactivation code, and see the disply change along with the state change

  Scenario: Viewing an inactive bomb
    Given an inactive bomb
    Then the image matches the status

  Scenario: View an active bomb
    Given an active bomb
    Then the image matches the status

  Scenario: View an exploded bomb
    Given an exploded bomb
    Then the image matches the status
    And the code input field is gone
    And the submit button is gone

