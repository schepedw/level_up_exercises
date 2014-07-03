Feature: Bomb tracks incorrect attempts to deactivate
  In order to keep non-villains from turning the bomb off
  As a supervillain
  The bomb should explode after 3 consecutive incorrect attempts to deactive

  Scenario: Attempting to deactivate bomb
    Given an active bomb
    When I enter the incorrect deactivation code 3 times
    Then the bomb explodes

