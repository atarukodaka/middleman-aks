Feature: category page

  Scenario: category summary
    Given a fixture app "category-app"
    And the Server is running at "category-app"
    When I go to "categories.html"
    Then the status code should be "200"
    And I should see "Categories"
    And I should see "cooking/egg.html"
    And I should see "categories/cooking.html"

    When I go to "categories/cooking.html"
    Then the status code should be "200"
