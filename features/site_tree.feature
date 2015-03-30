Feature: site tree
  Scenario: site tree build
    Given a fixture app "basic-app"
    And an index_template exists
    And an archives year template exists
    And a sitemap page named "source/sitemap.html.erb" exists

    When I run `middleman build --verbose`
    Then a file named "build/sitemap.html" should exist

  Scenario: site tree server    
#    Given a fixture app "site-tree-app"
    Given a fixture app "basic-app"
    And current environment is ":development"
    And an index_template exists    
    And a sitemap page named "source/sitemap.html.erb" exists
    And an archives year template exists
    And the Server is running at "site-tree-app"

    When I go to "/sitemap.html"
    Then I should see "sitemap"
    And I should see "<ul>"


