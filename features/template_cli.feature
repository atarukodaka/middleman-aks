Feature: template CLI

  Scenario: create a new project
    Given I run `middleman init MY_PROJECT --template aks`
    And the exit status should be 0
    When I cd to "MY_PROJECT"
    Then the following files should exist:
      | Gemfile                 |
      | source/index.html.erb   |
      | source/sitemap.html.erb |

  Scenario: build with new project
    Given I run `middleman init MY_PROJECT --template aks`
    And the exit status should be 0
    And I cd to "MY_PROJECT"
    When I run `middleman build --verbose`
    Then the exit status should be 0
    And the following files should exist:
    | build/index.html |



