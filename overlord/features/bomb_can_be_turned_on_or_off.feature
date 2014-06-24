#encoding: utf -8
Feature: Change the current state of the bomb
  In order to reverse the bomb's current state (on->off)/(off->on)
  As a supervillain
  I should be able to enter the correct activation/deacitivation code, and change the bomb's state

  Scenario: Turning a bomb on
    Given an inactive bomb
    When I enter the correct activation code
    Then the bomb is activated
    And the timer begins counting down from its current state

  Scenario: Turning a bomb off
    Given an active bomb
    When I enter the correct deactivation code
    Then the bomb is deactivated
    And the number of incorrect attempts is 0
    And the timer stops at its current state

