
locals {
  ## Indicates if the slack notification is enabled
  enable_slack = var.notification.slack != null

  ## If enabled, this will be the configuration for the slack notification
  slack_configuration = local.enable_slack ? {
    channel        = var.notification.slack.channel
    lambda_name    = var.notification.slack.lambda_name
    slack_username = ":aws: Budgets"
    webhook_url    = var.notification.slack.webhook_url
  } : null
}
