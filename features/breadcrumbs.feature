Feature: breadcrumbs

  Scenario: top page
    Given a fixture app "basic-app"
    And a file named "source/layouts/page.erb" with:
    """
      <%= breadcrumbs(current_page) %>
      <%= yield %>
      """
    And a file named "source/index.html.md" with:
      """
      ---
      title: top
      date: 2015-1-1
      layout: page
      ---
      top
      """
    And a file named "source/foo/bar.html.md" with:
      """
      ---
      title: bar
      date: 2015-1-1
      layout: page
      ---
      bar
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see:
      """
      <ol class="breadcrumb">
      """
    And I should see:
      """
      <li class="active">top</li>
      """
    When I go to "foo/bar.html"
    Then I should see:
      """
      <ol class="breadcrumb">
      """
    And I should see:
      """
      <li class="active">bar</li>
      """
     
