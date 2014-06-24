#encoding utf - 8
Feature: The bomb interface has a field to type in activation/deactivation code
  In order to turn the bomb on/off
  As a supervillain
  I should be able to enter a code into the activation/deactivation field

  Scenario: Entering code into activation/deactivation field
    Given a device with a working internet connection
    When I navigate to localhost:9393
    Then I should see a field in which to enter an activation/deactivation field
