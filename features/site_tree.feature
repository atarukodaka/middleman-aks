Feature: site tree
  Scenario: site tree build
    Given a fixture app "basic-app"
    And a file named "source/sitemap.html.erb" with:
      """
      <h2>sitemap</h2>
      <%= aks.show_tree() %>
      """
    When I run `middleman build --verbose`
    Then a file named "build/sitemap.html" should exist

  Scenario: site tree server    
    Given a fixture app "basic-app"
    And a file named "source/sitemap.html.erb" with:
      """
      <h2>sitemap</h2>
      <%= aks.show_tree() %>
      """
    And the Server is running at "basic-app"
    When I go to "/sitemap.html"
    Then I should see "sitemap"
    And I should see "<ul>"


