@Example
@BrowserStack
Feature: Running against a web browser

  Scenario: Using the Auth Login Stub
    Given a user wants to use the Auth Login Stub
    When they enter valid auth criteria
    Then they are redirected to that service