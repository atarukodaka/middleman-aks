Feature: archives

  Scenario: archives
    Given the Server is running at "archives-app"
    When I go to "/index.html"
    Then I should see "Welcome"
    When I go to "/game/kancolle/memo.html"
    Then I should see "kancolle memo"
    When I go to "/archives/2015/index.html"
    Then I should see "Archives for 2015"
    When I go to "/archives/2015/03.html"
    Then I should see "Archives for Mar 2015"
    



