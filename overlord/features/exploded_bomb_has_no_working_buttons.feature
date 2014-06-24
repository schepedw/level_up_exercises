#encoding: utf-8
Feature: An exploded bomb has no working buttons
  In order to observe bomb has exploded
  As any observer
  I should not be able to send any signals to the bomb

  Scenario: Bomb has exploded
    Given an exploded bomb
    When I give it any input
    Then nothing should happen
