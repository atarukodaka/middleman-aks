Feature: summary text

  Scenario: index_template
    Given a fixture app "basic-app"
    And a file named "source/file_to_summarize.html" with:
      """
      <big>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</big>
      """
    And a file named "source/index.html.erb" with:
      """
      ---
      ---
      <% page = page_for("/file_to_summarize.html") %>
      <%= page.summary_text(5, "...read more") %>
      """
    And the Server is running at "basic-app"
    
    When I go to "/index.html"
    Then the status code should be "200"
    And I should see "xxxxx"
    And I should not see "xxxxxx"
    And I should not see "big"
    And I should see "...read more</a>"



