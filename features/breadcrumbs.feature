Feature: 

  Scenario: breadcrumbs
    Given the Server is running at "breadcrumbs-app"
    When I go to "/game/kancolle/memo.html"
    Then I should see:
      """
      <ol class="breadcrumb">
      """
    



