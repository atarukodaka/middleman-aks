Feature: breadcrumbs

  Scenario: breadcrumbs
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      <%= breadcrumbs(current_page) %>
      """
    And the Server is running at "basic-app"
    When I go to "/index.html"
    Then I should see:
      """
      <ol class="breadcrumb">
      """


  Scenario: non-bootstrap
    Given a fixture app "basic-app"
    And a file name "source/foo/bar.html.erb" with:
      """
      <%= breadcrumbs(current_page, bootstrap_style: false, delimiter: '|') %>
      """
    When I goto "/foo/bar.html"
    Then I should see:
      """
      foo
      """



