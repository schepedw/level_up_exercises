#encoding: utf-8
Feature: Bomb has timer
  In order to give a countdown to the bomb exploding
  As a supervillain
  I should be able to see the time left until an activated bomb explodes

  Scenario: Starting timer
    Given An inactive bomb
    When I activate it
    Then the bomb's timer should start counting down from 30 seconds

  Scenario: Timer reaches 0
    Given an active bomb
    When the timer reaches 0
    Then the bomb explodes
