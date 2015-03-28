Feature: activate the extension

  Scenario: activate app
    Given a fixture app "empty-app"
    And a file named "config.rb" with:
      """
      activate :aks
      """
    And a file named "source/index.html.erb" with:
      """
      ---
      title: Top
      ---
      Welcome
      """
    And the Server is running at "empty-app"
#    Given a fixture app "empty-app"
    When I go to "/index.html"
    Then I should see "Welcome"
#    When I run `middleman build --verbose`
#    Then the exit status should be 0
#    And the file "build/index.html" should contain "Welcome"
