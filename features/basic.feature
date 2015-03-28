Feature: basic

  Scenario: basic
    Given the Server is running at "basic-app"
    When I go to "/index.html"
    Then I should see "Welcome"
    When I go to "/profile.html"
    Then I should see "Profile"
    When I go to "/hobby/sports/baseball.html"
    Then I should see "I like to play baseball"

    



