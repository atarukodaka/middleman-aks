Feature: build resources with middleman-aks

  Scenario: build with middleman-aks
    Given a fixture app "build-app"
    When I run `middleman build --verbose`
    Then the exit status should be 0
    And the following files should exist: 
      | build/index.html                  |
      | build/game/kancolle/memo.html         |
      | build/archives/2015/index.html    |
      | build/archives/2015/03.html       |
