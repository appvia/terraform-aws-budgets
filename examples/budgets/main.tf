#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

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

  budgets = var.budgets
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
