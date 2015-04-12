Feature: basic

  Scenario: basic
    Given the Server is running at "basic-app"

    When I go to "/index.html"
    Then I should see "Welcome"

    When I go to "/articles/cooking/egg.html"
    Then the status code should be "200"


    



