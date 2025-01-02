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

## Read the secret for aws secrets manager
data "aws_secretsmanager_secret" "notification" {
  name = var.notification_secret_name
}

## Retrieve the current version of the secret
data "aws_secretsmanager_secret_version" "notification" {
  secret_id = data.aws_secretsmanager_secret.notification.id
}

module "budgets" {
  source = "../../modules/budgets"

  budgets = local.budgets
  notifications = {
    email = {
      addresses = var.notification_emails
    }
    slack = {
      webhook_url = jsondecode(data.aws_secretsmanager_secret_version.notification.secret_string).webhook_url
    }
  }
  tags = var.tags
}
