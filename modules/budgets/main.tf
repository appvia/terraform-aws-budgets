
## Provision the SNS topic for the budgets if required and notifications 
module "notifications" {
  source  = "appvia/notifications/aws"
  version = "1.0.8"

  allowed_aws_services = [
    "budgets.amazonaws.com",
    "lambda.amazonaws.com",
  ]
  create_sns_topic          = var.create_sns_topic
  sns_topic_name            = var.sns_topic_name
  enable_slack              = local.enable_slack
  slack                     = local.slack_configuration
  tags                      = var.tags
  accounts_id_to_name       = var.accounts_id_to_name
  identity_center_start_url = var.identity_center_start_url
  identity_center_role      = var.identity_center_role
}

## Iterate over the budgets and provision them 
resource "aws_budgets_budget" "this" {
  for_each = { for x in var.budgets : x.name => x }

  name              = each.value.name
  budget_type       = each.value.budget_type
  limit_amount      = each.value.limit_amount
  tags              = merge(var.tags, try(each.value.tags, {}))
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
    subscriber_email_addresses = var.notifications.email != null ? var.notifications.email.addresses : null
    subscriber_sns_topic_arns  = [module.notifications.sns_topic_arn]
    threshold                  = each.value.notification.threshold
    threshold_type             = each.value.notification.threshold_type
  }

  depends_on = [module.notifications]
}
