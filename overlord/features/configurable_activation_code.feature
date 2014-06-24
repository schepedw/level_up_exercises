#encoding: utf-8
Feature: Configurable bomb activation code
  In order to specify the bomb activation code
  As a supervillain
  I should be able to pass -a=xxxx as a command line argument when I start the bomb interface

  Scenario: Configuring bomb activation code
    Given a terminal with sinatra installed
    When I enter 'ruby bomb_interface.rb -a=xxxx'
    Then the bomb's activation code should be xxxx
    And each x represents a number

  Scenario: Default bomb activation code
    Given a terminal with sinatra installed
    When I enter 'ruby bomb_interface.rb'
    Then the bomb's activation code should be 1234
