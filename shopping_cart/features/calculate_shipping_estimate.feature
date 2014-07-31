Feature: Calculate a shipping estimate
  In order to get an estimate of shipping cost
  As a customer
  I should be able to enter my address and get a shipping estimate

  Scenario: Logged in user asks for shipping estimate
    Given I have logged in
    When I ask for a shipping estimate
    Then I should not be asked for my address
    And I should receive a shipping estimate

  Scenario: Anonymous user asks for shipping estimate
    Given I am not logged in
    When I ask for a shipping estimate
    Then I should be given the option to log in

  Scenario: Anonymous user gets shipping estimate
    Given I have asked for a shipping estimate
    When I chose not to log in
    Then I should be prompted for my address

  Scenario: Anonymous user gets shipping estimate
    Given I have been prompted for my address
    When I enter my address
    Then I should receive a shipping estimate
