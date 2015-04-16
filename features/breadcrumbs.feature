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
    And a file named "source/layouts/page.erb" with:
      """
      <%= breadcrumbs(current_page) %>
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
      <ol class="breadcrumb"><li><a href="/">top</a></li><li>foo</li><li class="active">bar</li>
      """
    And I should see:
      """
      <li class="active">bar</li>
      """
    When I go to "2015-10-10-baz.html"
    Then I should see:
      """
      <li class="active">baz</li></ol>
      """
     
