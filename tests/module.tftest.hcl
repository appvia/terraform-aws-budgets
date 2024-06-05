mock_provider "aws" {}

run "basic_account_budget" {
  command = plan

  module {
    source = "./modules/budgets"
  }

  variables {
    notifications = {
      email = {
        addresses = ["platform-engineering@myorg.com"]
      }
      slack = {
        channel     = "dev-alerts"
        webhook_url = "https://my-dev-alerts.slack.com"
      }
    }
    budgets = [
      {
        name         = "AWS Savings Plan Coverage Budget"
        budget_type  = "SAVINGS_PLANS_COVERAGE"
        limit_amount = "100.0"
        limit_unit   = "PERCENTAGE"
        time_unit    = "MONTHLY"

        notification = {
          comparison_operator = "LESS_THAN"
          threshold           = "100"
          threshold_type      = "PERCENTAGE"
          notification_type   = "ACTUAL"
        }
      },
    ]
  }

  assert {
    condition     = length(var.budgets.0.name) >= 1 && length(var.budgets.0.name) < 100
    error_message = "Name should consist of minimum of 1 and maximum of 100 characters"
  }

  assert {
    condition     = contains(["USAGE", "COST", "RI_UTILIZATION", "RI_COVERAGE", "SAVINGS_PLANS_UTILIZATION", "SAVINGS_PLANS_COVERAGE"], var.budgets.0.budget_type)
    error_message = "Not a valid budge type"
  }

  assert {
    condition     = contains(["DAILY", "MONTHLY", "QUARTERLY", "ANNUALLY"], var.budgets.0.time_unit)
    error_message = "Not a valid budge time unit"
  }
}

run "basic_team_budget" {
  command = plan

  module {
    source = "./modules/team-budgets"
  }
}
