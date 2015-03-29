Feature: simple server

  Scenario: simple
    Given the Server is running at "basic-app"
    When I go to "/index.html"
    Then I should see "Welcome"
