Feature: template CLI

  Scenario: create a new project
    Given I run `middleman init MY_PROJECT --template aks`
    And the exit status should be 0
    When I cd to "MY_PROJECT"
    Then the following files should exists:
      | source/index.html.md |

    



