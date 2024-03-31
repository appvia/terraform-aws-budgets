

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
