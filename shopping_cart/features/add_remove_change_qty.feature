Feature: Add, remove, and change quantities on items in my cart
  In order to purchase the correct items in the correct quantities
  As a customer
  I should be able to add, remove, and change quantities for items in my cart

  Scenario: Add item to shopping cart
    When I add an item my cart
    Then the item is included in my cart

  Scenario: Remove an item from shopping cart
    Given I have at least one item in my shopping cart
    When I remove an item
    Then the item is removed from my cart

  Scenario: Change quantity of item in cart
    Given I have at least one item in my shopping cart
    When I change the quantity for that item to any number
    Then I have that quantity of that item
    And the quantity for that item cannot be negative
  
  Scenario: Change quantity of item to 0
    Given I have at least one item in my shopping cart
    When I change the quantity of that item to 0
    Then the item is removed from my cart

  Scenario: Logging in after adding items to a cart
    Given I am not logged in
    And I have at least one item in my shopping cart
    When I log in
    Then my shopping cart remains unchanged

  Scenario: Logging out after adding items to a cart
    Given I am logged in
    And I have at least one item in my shopping cart
    When I log out
    Then I am given the option to empty my shopping cart

  Scenario: Adding item with duplicate SKU
    Given I am logged in
    And I have at least one item in my shopping cart
    When I try to add a duplicate item to my shoppping cart
    Then the quantity of the item in my cart should increase by 1
