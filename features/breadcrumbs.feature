Feature: breadcrumbs

  Scenario: breadcrumbs
    Given a fixture app "basic-app"
    And a file named "source/foo/index.html.erb" with:
      """
      <%= breadcrumbs(current_page) %>
      """
    And the Server is running at "basic-app"
    When I go to "/foo/index.html"
    Then I should see:
      """
      <ol class="breadcrumb">
      """


  Scenario: non-bootstrap style
    Given a fixture app "basic-app"
    And a file named "source/foo/index.html.erb" with:
      """
      <%= breadcrumbs(current_page, bootstrap_style: false, delimiter: "|") %>
      """
    And the Server is running at "basic-app"
    When I go to "/foo/index.html"
    Then I should not see:
      """
      <ol class="breadcrumb">
      """
    And I should see:
      """
      Home
      """
