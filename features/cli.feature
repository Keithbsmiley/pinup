Feature: The CLI shows proper output
  In order for the user to understand what to do
  The CLI should produce the correct help dialogs
  So that no one gets confused

  Scenario: The CLI runs
    When there are no arguments
    Then it should print the help text
    When help is passed as an argument
    Then it should print the help text
  
  Scenario: Invalid arguments
    When the user passes an invalid command
    Then it should have the correct exit status
