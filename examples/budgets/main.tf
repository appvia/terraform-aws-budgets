#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

locals {
  ## The region
  region = "eu-west-2"

  ## The budgets
  budgets = [
    {
      name         = "AWS Monthly Budget for ${local.region} (Actual)"
      budget_type  = "COST"
      limit_amount = "100.0"
      limit_unit   = "USD"
      time_unit    = "MONTHLY"

      notification = {
        comparison_operator = "GREATER_THAN"
        threshold           = "80"
        threshold_type      = "PERCENTAGE"
        notification_type   = "ACTUAL"
      }

      cost_filter = {
        "Region" : {
          values = [local.region]
        }
      }
    },
    {
      name         = "AWS Monthly Budget for ${local.region} (Forecast)"
      budget_type  = "COST"
      limit_amount = "100.0"
      limit_unit   = "USD"
      time_unit    = "MONTHLY"

      notification = {
        comparison_operator = "GREATER_THAN"
        threshold           = "80"
        threshold_type      = "PERCENTAGE"
        notification_type   = "FORECASTED"
      }

      cost_filter = {
        "Region" : {
          values = [local.region]
        }
      }
    },
  ]
}

module "budgets" {
  source = "../../"

  budgets = local.budgets
  notifications = {
    email = {
      addresses = var.notification_emails
    }
  }
  tags = var.tags
}
