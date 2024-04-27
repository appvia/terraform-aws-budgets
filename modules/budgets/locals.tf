
locals {
  ## Indicates if the slack notification is enabled
  enable_slack = var.notifications.slack != null

  ## If enabled, this will be the configuration for the slack notification
  slack_configuration = local.enable_slack ? {
    channel     = var.notifications.slack.channel
    lambda_name = var.notifications.slack.lambda_name
    secret_name = var.notifications.slack.secret_name
    username    = var.notifications.slack.username
    webhook_url = var.notifications.slack.webhook_url
  } : null
}
