Feature: syntax highlight

  Scenario: syntax highlight
#    Given the Server is running at "syntax-app"
    Given a fixture app "syntax-app"
    When I run `bundle exec middleman build --verbose`
    Then the file "build/index.html" should contain "hoge"
    And  the file "build/index.html" should contain "<code>"
    And  the file "build/index.html" should contain "<html>"
    And  the file "build/index.html" should contain "syntax.css"
    And  the file "build/stylesheets/syntax.css" should contain ".highlight"
#    When I go to "/index.html"
#    Then I should see "hoge"
#    And I should see ".highlight"
