Feature: blog article
  Scenario: summary_text
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      ---
      ---
      <% target_page = page_for("foo/bar.html") %>
      <%= target_page.summary_text(5, "...") %>
      """
    And a file named "source/foo/bar.html.erb" with:
      """
      ---
      title: bar
      date: 2015-1-1
      ---
      123456789012345678901234567890
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see "12345"
    And I should not see "123456"
