
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
      name   = cost_filter.key
      values = cost_filter.value.values
    }
  }

  dynamic "notification" {
    for_each = each.value.notifications

    content {
      comparison_operator        = notification.value.comparison_operator
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = var.notifications.email != null ? var.notifications.email.addresses : null
      subscriber_sns_topic_arns  = var.notifications.sns != null ? [var.notifications.sns.topic_arn] : null
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
    }
  }
}

