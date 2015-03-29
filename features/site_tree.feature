Feature: site tree
  Scenario: site tree build
    Given a fixture app "site-tree-app"
    When I run `middleman build --verbose`
    Then a file named "build/sitemap.html" should exist

  Scenario: site tree server    
    Given a fixture app "site-tree-app"
    And the Server is running at "site-tree-app"
    When I go to "/sitemap.html"
    Then I should see "sitemap"
    And I should see "<ul>"


