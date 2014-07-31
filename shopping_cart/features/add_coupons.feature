Feature: Add a coupon to an order
  In order receive a discount on my odrer
  As a customer
  I should be able to enter a coupon related to one of the items in my cart

  Scenario: Add a valid coupon to an order
    Given I have a coupon for an item in my cart
    When I enter the coupon code
    Then I should receive the discount related to that coupon

  Scenario: Add an coupon to order that does not have corresponding items
    Given I have a coupon that does not correspond to any item in my cart
    When I enter the coupon code
    Then my order total should not change

  Scenario: Add an expired coupon
    Given I have an expired coupon
    When I enter the coupon code
    Then my order total should not change

  Scenario: Add a duplicate coupon
    Given I have entered a coupon
    When I enter the same coupon again
    Then my order total should not change
