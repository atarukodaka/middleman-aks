Feature: helpers
  Scenario: resource
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      ---
      title: top
      ---
      page_for: <%= page_for("/index.html").path %>
      link_to_page: <%= link_to_page("/index.html") %>
      """
    And the Server is running at "basic-app"
    When I go to "/index.html"
    Then I should see "page_for: index.html"
    And I should see:
      """
      link_to_page: <a href="/">top</a>
      """

  Scenario: copyright single year
    Given a fixture app "basic-app"
    And a file named "source/foo/bar.html.erb" with:
      """
      ---
      date: 2015-1-1
      ---
      copyright: <%= copyright %>
      """
    When I append to "config.rb" with:
      """
      set :site_author, 'author'
      set :site_email, 'your@email.com'
      """
    And the Server is running at "basic-app"
    And I go to "/foo/bar.html"
    Then I should see "&copy; 2015 by author (your@email.com)"

  Scenario: copyright multiple years
    Given a fixture app "basic-app"
    And a file named "source/foo/bar.html.erb" with:
      """
      ---
      date: 2015-1-1
      ---
      copyright: <%= copyright %>
      """
    And a file named "source/foo/baz.html.erb" with:
      """
      ---
      date: 2010-1-1
      ---
      """
    When I append to "config.rb" with:
      """
      set :site_author, 'author'
      set :site_email, 'your@email.com'
      """
    And the Server is running at "basic-app"
    And I go to "/foo/bar.html"
    Then I should see "&copy; 2010-2015 by author (your@email.com)"
