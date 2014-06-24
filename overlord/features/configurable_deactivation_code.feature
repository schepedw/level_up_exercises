#encoding: utf-8
Feature: Configurable bomb deactivation code
  In order to specify the bomb deactivation code
  As a supervillain
  I should be able to pass -d=xxxx as a command line argument when I start the bomb interface

  Scenario: Configuring bomb deactivation code
    Given a terminal with sinatra installed
    When I enter 'ruby bomb_interface.rb -d=xxxx'
    Then the bomb's deactivation code should be xxxx
    And each x represents a number

  Scenario: Default bomb activation code
    Given a terminal with sinatra installed
    When I enter 'ruby bomb_interface.rb'
    Then the bomb's deactivation code should be 0000
