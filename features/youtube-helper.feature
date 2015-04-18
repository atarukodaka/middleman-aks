Feature: youtube

  Scenario: only id specified
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      <%= youtube('abcd1234') %>
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see:
      """
      <iframe width="560" height="315" src="http://www.youtube.com/embed/abcd1234"></iframe>
      """


  Scenario: width specified
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      <%= youtube('abcd1234', width: 560) %>
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see:
      """
      <iframe width="560" height="315" src="http://www.youtube.com/embed/abcd1234"></iframe>
      """

  Scenario: height specified
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      <%= youtube('abcd1234', height: 315) %>
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see:
      """
      <iframe width="560" height="315" src="http://www.youtube.com/embed/abcd1234"></iframe>
      """

  Scenario: time
    Given a fixture app "basic-app"
    And a file named "source/index.html.erb" with:
      """
      <%= youtube('abcd1234', t: 140) %>
      """
    And the Server is running at "basic-app"
    When I go to "index.html"
    Then I should see:
      """
      <iframe width="560" height="315" src="http://www.youtube.com/embed/abcd1234?t=140"></iframe>
      """
