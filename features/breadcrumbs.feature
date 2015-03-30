Feature: 

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
    



