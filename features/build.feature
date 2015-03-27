Feature: build resources with middleman-aks

  Scenario: build with middleman-aks
    Given a fixture app "aks-app"
    When I run `middleman build --verbose`
    Then the exit status should be 0
    And the file "build/index.html" should contain 'welcome'