## Get the current account id
data "aws_caller_identity" "current" {}

locals {
  # The account id 
  account_id = data.aws_caller_identity.current.account_id
  # Check if the slack notifications are enabled
  enable_slack = var.notification.slack != null
}

locals {
  # sns topic arn 
  sns_topic_arn = var.create_sns_topic ? module.notifications[0].topic_arn : format("arn:aws:sns:%s::%s", local.account_id, var.sns_topic_name)
}

## Provision the SNS topic for the budgets if required
module "notifications" {
  source  = "terraform-aws-modules/sns/aws"
  version = "v6.0.1"
  count   = var.create_sns_topic ? 1 : 0

  name = var.sns_topic_name
  tags = var.tags
  topic_policy_statements = {
    "AllowBudgetsToNotifySNSTopic" = {
      actions = ["sns:Publish"]
      effect  = "Allow"
      principals = [{
        type        = "Service"
        identifiers = ["budgets.amazonaws.com"]
      }]
    }
    "AllowLambda" = {
      actions = [
        "sns:Subscribe",
      ]
      effect = "Allow"
      principals = [{
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }]
    }
  }
}

## Iterate over the budgets and provision them 
resource "aws_budgets_budget" "this" {
  for_each = { for x in var.budgets : x.name => x }

  name              = each.value.name
  account_id        = lookup(each.value, "account_id", null)
  budget_type       = each.value.budget_type
  limit_amount      = each.value.limit_amount
  limit_unit        = lookup(each.value, "limit_unit", "USD")
  time_period_start = lookup(each.value, "time_period_start", null)
  time_period_end   = lookup(each.value, "time_period_end", null)
  time_unit         = lookup(each.value, "time_unit", "MONTHLY")

  dynamic "auto_adjust_data" {
    for_each = lookup(each.value, "auto_adjust_data", null) != null ? try(tolist(each.value.auto_adjust_data), [
      each.value.auto_adjust_data
    ]) : []

    content {
      auto_adjust_type = auto_adjust_data.value.auto_adjust_type
    }
  }

  dynamic "cost_types" {
    for_each = lookup(each.value, "cost_types", null) != null ? [each.value.cost_types] : []

    content {
      include_credit             = lookup(cost_types.value, "include_credit", null)
      include_discount           = lookup(cost_types.value, "include_discount", null)
      include_other_subscription = lookup(cost_types.value, "include_other_subscription", null)
      include_recurring          = lookup(cost_types.value, "include_recurring", null)
      include_refund             = lookup(cost_types.value, "include_refund", null)
      include_subscription       = lookup(cost_types.value, "include_subscription", null)
      include_support            = lookup(cost_types.value, "include_support", null)
      include_tax                = lookup(cost_types.value, "include_tax", null)
      include_upfront            = lookup(cost_types.value, "include_upfront", null)
      use_blended                = lookup(cost_types.value, "use_blended", null)
    }
  }

  dynamic "cost_filter" {
    for_each = each.value.cost_filter

    content {
      name   = cost_filter.value.name
      values = cost_filter.value.values
    }
  }

  notification {
    comparison_operator        = each.value.notification.comparison_operator
    notification_type          = each.value.notification.notification_type
    subscriber_email_addresses = var.notification.email != null ? var.notification.email.addresses : null
    subscriber_sns_topic_arns  = [local.sns_topic_arn]
    threshold                  = each.value.notification.threshold
    threshold_type             = each.value.notification.threshold_type
  }

  depends_on = [module.notifications]
}

#
## Provision the slack notification if enabled
#
# tfsec:ignore:aws-lambda-enable-tracing
# tfsec:ignore:aws-lambda-restrict-source-arn
module "slack" {
  count   = local.enable_slack ? 1 : 0
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "6.1.1"

  create_sns_topic     = false
  lambda_function_name = var.notification.slack.lambda_name
  slack_channel        = var.notification.slack.channel
  slack_username       = ":aws: Budgets"
  slack_webhook_url    = var.notification.slack.webhook_url
  sns_topic_name       = var.sns_topic_name
  tags                 = var.tags
}
