Feature: published: false

  Scenario: non published
    Given a fixture app "basic-app"
    And a file named "config.rb" with:
      """
      set :environment, :test
      activate :blog do |blog|
      blog.prefix = "articles"
      blog.sources = "{category}/{title}.html"
      blog.permalink = "{category}/{title}.html"
      blog.layout = "article"
      end
      
      activate :aks
      """
    And a file named "source/articles/foo/non-published.html.md" with:
      """
      ---
      date: 2015-3-1
      published: false
      ---
      - foo
      """
    And current environment is "test"
    And the Server is running at "basic-app"
    When I go to "/articles/foo/non-published.html"
    Then the status code should be "404"

    



