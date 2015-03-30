Feature: archives

  Scenario: archives
    Given a fixture app "basic-app"
    And an archives year template exists
    And an archives month template exists
    And the Server is running at "basic-app"
    
    When I go to "/archives/2015/index.html"
    Then the status code should be "200"

    When I go to "/archives/2015/03.html"
    Then the status code should be "200"
