Feature: build resources with middleman-aks

  Scenario: build with middleman-aks
    Given a fixture app "basic-app"
    When I run `middleman build --verbose`
    Then the exit status should be 0
    And the following files should exist: 
      | build/index.html               |
      | build/profile.html             |
      | build/hobby/sports/baseball.html |

