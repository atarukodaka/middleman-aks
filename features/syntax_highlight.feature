Feature: syntax highlight

  Scenario: syntax highlight
    Given a fixture app "basic-app"
    And a file named "source/index.html.md" with:
      """
      ---
      layout: syntax
      ---
      ```ruby
      def foo
        puts :bar
      end
      ```
      """
    And a file named "source/layouts/syntax.erb" with:
      """
      <%= stylesheet_link_tag "syntax.css" %>

      <%= yield %>
      """
    And a file named "source/stylesheets/syntax.css.erb" with:
      """
      <%= Rouge::Themes::ThankfulEyes.render(:scope => '.highlight') %>
      """
    When I append to "config.rb" with:
      """
      require 'middleman-syntax'
      set :markdown_engine, :redcarpet
      set :markdown, :fenced_code_blocks => true, :smartypants => true
      activate :syntax
      """
    And the Server is running at "basic-app"
    And I go to "index.html"
    Then I should see:
      """
      <link href="/stylesheets/syntax.css" rel="stylesheet" type="text/css" />
      """
    And I should see:
      """
      <pre class="highlight ruby"><code><span class="k">def</span>
      """
