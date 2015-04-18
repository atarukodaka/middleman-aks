Feature: pagination
  Scenario: page
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      ---
      per_page: 1
      pageable: true
      ---
      <% pages = current_page.paginated_resources %>
      <% pages.each do |page| %>
      <%= link_to_page(page) %>
      <% end %>
      """
    And a file named "source/foo/01.html.md" with:
      """
      ---
      title: 01
      date: 2015-1-1
      ---
      01
      """
    And a file named "source/foo/02.html.md" with:
      """
      ---
      title: 02
      date: 2015-1-2
      ---
      02
      """
    And a file named "source/foo/03.html.md" with:
      """
      ---
      title: 03
      date: 2015-1-3
      ---
      03
      """
    And a file named "source/foo/04.html.md" with:
      """
      ---
      title: 04
      date: 2015-1-4
      ---
      04
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see:
      """
      <a href="/p2/"></a>
      <a href="/p3/"></a>
      <a href="/p4/"></a>
      """
