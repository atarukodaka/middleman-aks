Feature: syntax highlight

  Scenario: syntax highlight
#    Given the Server is running at "syntax-app"
    Given a fixture app "syntax-app"
    When I run `middleman build --verbose`
    Then the file "build/index.html" should contain:
      """
      <pre class="highlight ruby"><code><span class="k">def</span> 
      """
    And  the file "build/index.html" should contain "<html>"
    And  the file "build/index.html" should contain:
      """
      <link href="/stylesheets/syntax.css" rel="stylesheet" type="text/css" />
      """
    And  the file "build/stylesheets/syntax.css" should contain ".highlight table td"
