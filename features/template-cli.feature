Feature: template ci
  Scenario: new proj
    Given I run `middleman init proj --template aks`
    And the exit status should be 0
    When I cd to "proj"
    Then the following files should exist:
      | Gemfile                                                   |
      | .gitignore                                                |
      | config.rb                                                 |
      | source/index.html.erb                                     |
      | source/cooking/egg.html.md                                |
      | source/partials/_navbar.erb                               |
      | source/partials/_sidebar.erb                              |
      | source/partials/_summary.erb                              |
      | source/profile.html.md.erb                                |
      | source/sitemap.html.erb                                   |
      | source/proxy_templates/archives_yearly_template.html.erb  |
      | source/proxy_templates/archives_monthly_template.html.erb |
      | source/proxy_templates/category_template.html.erb         |




