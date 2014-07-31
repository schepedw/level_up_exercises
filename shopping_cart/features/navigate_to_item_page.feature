Feature: Navigate to item page
  In order to review the items in my cart
  As a customer
  I should be able to click an item to go back to its page

  Scenario: Going back to product page
    Given I have at least one item in my cart
    When I click on that item
    I should be taken to that item's product page
