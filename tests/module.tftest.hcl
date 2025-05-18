mock_provider "aws" {
  mock_data "aws_region" {
    defaults = {
      name           = "eu-west-2"
      current_region = "eu-west-2"
    }
  }

  mock_data "aws_partition" {
    defaults = {
      partition = "aws"
    }
  }

  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
      user_arn   = "arn:aws:iam::123456789012:user/terraform"
      user_id    = "AIDACKCEVSQ6C2EXAMPLE"
    }
  }
}

run "budgets" {
  command = plan

  module {
    source = "./modules/budgets"
  }

  variables {
    notifications = {
      email = {
        addresses = ["platform-engineering@myorg.com"]
      }
      sns = {
        topic_arn = "arn:aws:sns:us-west-2:123456789012:my-topic"
      }
    }
    budgets = [
      {
        name         = "AWS Savings Plan Coverage Budget"
        budget_type  = "SAVINGS_PLANS_COVERAGE"
        limit_amount = "100.0"
        limit_unit   = "PERCENTAGE"
        time_unit    = "MONTHLY"

        notifications = {
          actual = {
            comparison_operator = "LESS_THAN"
            threshold           = "100"
            threshold_type      = "PERCENTAGE"
            notification_type   = "ACTUAL"
          }
          forecasted = {
            comparison_operator = "LESS_THAN"
            threshold           = "100"
            threshold_type      = "PERCENTAGE"
            notification_type   = "FORECASTED"
          }
        }
      },
    ]
    tags = {
      Environment = "Test"
    }
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

  ## Should create a budget for each budget in the budgets array
  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"] != null
    error_message = "Budget should be created"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].name == "AWS Savings Plan Coverage Budget"
    error_message = "Budget name should be AWS Savings Plan Coverage Budget"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].budget_type == "SAVINGS_PLANS_COVERAGE"
    error_message = "Budget type should be SAVINGS_PLANS_COVERAGE"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].limit_amount == "100.0"
    error_message = "Budget limit amount should be 100.0"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].limit_unit == "PERCENTAGE"
    error_message = "Budget limit unit should be PERCENTAGE"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].time_unit == "MONTHLY"
    error_message = "Budget time unit should be MONTHLY"
  }

  assert {
    condition     = length(aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].notification) == 2
    error_message = "Budget notifications should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_credit == false
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_discount == false
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_recurring == false
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_refund == false
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_subscription == true
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_support == false
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_tax == false
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.include_upfront == false
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.use_amortized == null
    error_message = "Budget cost types should be correct"
  }

  assert {
    condition     = aws_budgets_budget.this["AWS Savings Plan Coverage Budget"].cost_types.0.use_blended == false
    error_message = "Budget cost types should be correct"
  }
}
