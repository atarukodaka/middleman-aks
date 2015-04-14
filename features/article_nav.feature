Feature: article navigation

  Scenario: latest article
    Given a fixture app "basic-app"
    And a file named "source/layouts/article.erb" with:
      """
      <%= yield %>
      <ul class="pager">
	<%= article_navigator(:previous, current_article.previous_article) %>
	<%= article_navigator(:next, current_article.next_article) %>
      </ul>
      """
    And a file named "source/foo/a.html.md" with:
     """
     ---
     title: a
     date: 2015-1-1
     ---
     a.html
     """
    And a file named "source/foo/b.html.md" with:
     """
     ---
     title: b
     date: 2015-1-2
     ---
     b.html
     """
    And a file named "source/foo/c.html.md" with:
     """
     ---
     title: c
     date: 2015-1-3
     ---
     c.html
     """

    And the Server is running at "basic-app"
    When I go to "foo/c.html"
    Then I should see:
      """
      <li class="next disabled"><a data-toggle="tooltip" title="" href="#"><span>&rarr;</span></a>
      """
    And I should see:
      """
      <li class="previous"><a data-toggle="tooltip" title="b" href="/foo/b.html"><span>&larr;</span>b</a>
      """
    When I go to "foo/b.html"
    Then I should see:
      """
      <li class="next"><a data-toggle="tooltip" title="c" href="/foo/c.html">c<span>&rarr;</span></a>
      """
    And I should see:
      """
      <li class="previous"><a data-toggle="tooltip" title="a" href="/foo/a.html"><span>&larr;</span>a</a>
      """

    When I go to "foo/a.html"
    Then I should see:
      """
      <li class="next"><a data-toggle="tooltip" title="b" href="/foo/b.html">b<span>&rarr;</span></a>
      """
    And I should see:
      """
      <li class="previous disabled"><a data-toggle="tooltip" title="" href="#"><span>&larr;</span></a>
      """

  Scenario: long title to short
    Given a fixture app "basic-app"
    And a file named "source/layouts/article.erb" with:
      """
      <%= yield %>
      <ul class="pager">
	<%= article_navigator(:previous, current_article.previous_article) %>
	<%= article_navigator(:next, current_article.next_article) %>
      </ul>
      """
    And a file named "source/foo/a.html.md" with:
     """
     ---
     title: a
     date: 2015-1-1
     ---
     a.html
     """
    And a file named "source/foo/b.html.md" with:
     """
     ---
     title: 12345678901234567890123456789012345678901234567890
     date: 2015-1-2
     ---
     b.html
     """
     And the Server is running at "basic-app"
     When I go to "foo/a.html"
     Then I should see:
       """
       <li class="next"><a data-toggle="tooltip" title="12345678901234567890123456789012345678901234567890" href="/foo/b.html">123456789012345678901234567890...<span>&rarr;</span></a></li>
       """
