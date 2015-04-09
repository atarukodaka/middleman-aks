Feature: index template

  Scenario: index_template
    Given a fixture app "basic-app"
    And an index_template exists
    And the Server is running at "basic-app"
    
    When I go to "/hobby/index.html"
    Then the status code should be "200"

    When I go to "/hobby/sports/index.html"
    Then the status code should be "200"


  Scenario: no top page but profile exists
    Given a fixture app "empty-app"
    And a file named "config.rb" with:
      """
      activate :aks
      """      
    And a file named "source/profile.html.md" with:
      """
      ---
      title: profile
      ---
      profile here
      """
    And the Server is running at "empty-app"

    When I go to "/profile.html"
    Then the status code should be "200"
    When I go to "/index.html"
    Then the status code should be "404"
    
  Scenario: no top page but create by index creator
    Given a fixture app "empty-app"
    And a file named "config.rb" with:
      """
      activate :aks
      """      
    And an index_template exists
    And the Server is running at "empty-app"

    When I go to "/index.html"
    Then the status code should be "200"



