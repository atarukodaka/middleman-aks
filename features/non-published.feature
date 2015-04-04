Feature: published: false

  Scenario: non published
    Given a fixture app "basic-app"
    And a file named "source/non-published.html.md" with:
      """
      ---
      published: false
      ---
      - foo
      """
    And the Server is running at "basic-app"
    When I go to "/non-published.html"
    Then the status code should be "404"

    



