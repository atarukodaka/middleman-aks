Feature: breadcrumbs

  Scenario: top page
    Given a fixture app "basic-app"
    And a file named "config.rb" with:
      """
      activate :blog do |blog|
        blog.layout = "page"
        blog.prefix = "/"
        blog.sources = "{year}/{month}/{day}/{title}.html"
        blog.permalink = "{year}-{month}-{day}-{title}.html"

        blog.custom_collections = {
          category: {
            link: '/categories/{category}.html',
            template: '/proxy_templates/category_template.html'
          }
        }
      end
      activate :aks
      """
    And a file named "source/partials/_breadcrumbs.erb" with:
      """
      <% page ||= current_page %>
      <% nodes = page.breadcrumbs_nodes %>

      <nav class="crumbs">
        <ol class="breadcrumb">
          <% nodes.each do |node| %>
          <li>
            <% if node.page %>
            <%= link_to(h(node.name), node.page) %>
            <% else %>
            <%= h(node.name) %>
            <% end %>
          </li>
          <% end %>
        </ol>
      </nav>
      """
    And a file named "source/layouts/page.erb" with:
      """
      <%= partial("partials/breadcrumbs") %>
      <%= yield %>
      """
    And a file named "source/index.html.md" with:
      """
      ---
      title: top
      layout: page
      ---
      top
      """
    And a file named "source/foo/bar.html.md" with:
      """
      ---
      title: bar
      layout: page
      ---
      bar
      """
    And a file named "source/2015/10/10/baz.html.md" with:
      """
      ---
      title: baz
      layout: page
      category: foo
      ---
      bar
      """
    And a file named "source/proxy_templates/category_template.html.erb" with:
      """
      <%= category %>
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see:
      """
      <ol class="breadcrumb">
      """

    And I should see "Home"
    When I go to "foo/bar.html"
    Then I should see "bar"

    When I go to "2015-10-10-baz.html"
    Then I should see:
      """
      <a href="/categories/foo.html">foo</a>
      """
     
