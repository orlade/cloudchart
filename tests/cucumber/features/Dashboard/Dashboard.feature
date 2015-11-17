Feature: Dashboard

  As an anonymous user
  I want to view the login page
  So that I can login to the app

  Background: User is logged in
    Given I am logged in

  @watch
  Scenario: View the Dashboard
    Given I am on the Dashboard
    Then I can see service cards
