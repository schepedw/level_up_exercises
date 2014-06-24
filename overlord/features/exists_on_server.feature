#encoding: utf-8

Feature: The bomb interface runs on a webserver
  In order to access the bomb from anywhere
  As a supervillain
  I should be able to navigate to localhost:9393 to see the bomb interface

  Scenario: Accessing bomb interface
    Given a device with an internet connection
    When I navigate to localhost:9393
    Then I should see the bomb interface
