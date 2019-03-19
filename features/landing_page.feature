Feature: Landing Page
  As an arbitrary internet user
  I want to know what this product does

  Scenario: User sees site tagline
    When I go to the homepage
    Then I should see "Analytics made simple"
