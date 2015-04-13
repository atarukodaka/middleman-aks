Feature: activate the extension

  Scenario: activate app
    Given a fixture app "empty-app"
    And a file named "config.rb" with:
      """
      set :layout, :page
      activate :blog do |blog|
        blog.prefix = ""
        blog.sources = "{category}/{title}.html"
        blog.permalink = "{category}/{title}.html"
        blog.layout = "article"
      end
      activate :aks
      """
    And a file named "source/index.html.erb" with:
      """
      ---
      title: Top
      ---
      Welcome
      """
    And a file named "source/cooking/egg.html.erb" with:
      """
      ---
      title: egg
      date: 2015-1-1
      ---
      cooking egg
      """
    And a file named "source/layouts/page.erb" with:
      """
      page layout:
      <%= yield %>
      """
    And a file named "source/layouts/article.erb" with:
      """
      article layout:
      <%= yield %>
      """
    And the Server is running at "empty-app"
    When I go to "/index.html"
    Then I should see "Welcome"

    When I go to "/cooking/egg.html"
    Then the status code should be "200"
    And I should see "cooking egg"
    And I should see "article layout:"
