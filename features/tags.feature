Feature: tags
  Scenario: tags.html and tag pages
    Given a fixture app "basic-app"
    And a file named "source/foo_tags.html.erb" with:
      """
      ---
      tags: foo
      ---
      """
    And a file named "source/foo_tag.html.erb" with:
      """
      ---
      tag: foo
      ---
      """
    And a file named "source/tags.html.erb" with:
      """
      <ul>
      <% aks.tags.each do |tag, pages| %>
      <li><%= h(tag) %>
        <ul>
          <% pages.each do |page| %>
          <li><%= link_to_page(page) %></li>
          <% end %>
        </ul>
      <% end %>
      </ul>
      
      """
    And a file named "source/templates/tag.html.erb" with:
      """
      ---
      ---
      <% tag ||= "" %>
      <% pages ||= [] %>

      Tag: <%= h(tag) %>

      <% pages.each do |page| %>
        <%= link_to_page(page) %>
      <% end %>

      """
    And the Server is running at "basic-app"

    When I go to "/tags/foo.html"
    Then I should see "Tag: foo"
    And I should see "foo_tags.html"
    And I should see "foo_tag.html"

