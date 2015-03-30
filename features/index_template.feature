Feature: index template

  Scenario: index_template
    Given a fixture app "basic-app"
    And an index_template exists
    And the Server is running at "basic-app"
    
    When I go to "/hobby/index.html"
    Then the status code should be "200"

    When I go to "/hobby/sports/index.html"
    Then the status code should be "200"
    



