Feature: index template working

  Scenario: index_template
    Given the Server is running at "index-template-app"
    When I go to "/index.html"
    Then I should see "Welcome"
    When I go to "/game/kancolle/memo.html"
    Then I should see "kancolle memo"
    When I go to "/game/kancolle/index.html"
    Then I should see "index name: kancolle"
    When I go to "/game/index.html"
    Then I should see "index name: game"
    



