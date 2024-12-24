#
## For each team budget, we need to create a SNS topic, a lamfda is then used to
## subscribe to the SNS topic and then send the notification to slack or teams
#
module "sns" {
  source   = "terraform-aws-modules/sns/aws"
  version  = "v6.0.1"
  for_each = { for budget in var.budgets : budget.name => budget }

  name = format("team-budgets-%s", md5(each.value.name))
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

## Provision any additional notification subscriptions (email)
resource "aws_sns_topic_subscription" "email" {
  for_each = { for x in var.budgets : x => x if x.notification.email != null }

  endpoint  = each.value
  protocol  = "email"
  topic_arn = module.sns[each.key].topic_arn
}

## Provisions a budgets for the products
resource "aws_budgets_budget" "this" {
  for_each = { for budget in var.budgets : budget.name => budget }

  budget_type  = each.value.budget_type
  limit_amount = each.value.amount
  limit_unit   = "USD"
  name         = each.value.name
  time_unit    = each.value.time_unit
  tags         = var.tags

  dynamic "cost_filter" {
    for_each = each.value.cost_filters
    content {
      name   = cost_filter.value.name
      values = cost_filter.value.values
    }
  }

  dynamic "cost_types" {
    for_each = each.value.cost_types != null ? [each.value.cost_types] : []
    content {
      include_credit             = cost_types.value.include_credit
      include_discount           = cost_types.value.include_discount
      include_other_subscription = cost_types.value.include_other_subscription
      include_recurring          = cost_types.value.include_recurring
      include_refund             = cost_types.value.include_refund
      include_subscription       = cost_types.value.include_subscription
      include_support            = cost_types.value.include_support
      include_tax                = cost_types.value.include_tax
      include_upfront            = cost_types.value.include_upfront
      use_blended                = cost_types.value.use_blended
    }
  }

  dynamic "notification" {
    for_each = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

    content {
      comparison_operator       = "GREATER_THAN"
      threshold                 = each.value.threshold
      threshold_type            = each.value.threshold_type
      notification_type         = each.value.notification_type
      subscriber_sns_topic_arns = [var.sns_topic_arn]
    }
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = each.value.threshold
    threshold_type            = each.value.threshold_type
    notification_type         = each.value.notification_type
    subscriber_sns_topic_arns = [module.sns[each.key].topic_arn]
  }

  depends_on = [module.sns]
}

#
## Provision a slack notification for the specific budget
#
# tfsec:ignore:aws-lambda-enable-tracing
# tfsec:ignore:aws-lambda-restrict-source-arn
module "slack_notfications" {
  for_each = { for budget in var.budgets : budget.name => budget if budget.slack_notification.slack != null }

  source  = "appvia/notifications/aws"
  version = "1.1.0"

  create_sns_topic = false
  enable_slack     = true
  slack = {
    webhook_url = each.value.slack_notification.slack_webhook_url
    lambda_name = format("team-budgets-notifications-%s", md5(each.value.name))
  }
  sns_topic_name            = module.sns[each.key].topic_name
  tags                      = var.tags
  accounts_id_to_name       = var.accounts_id_to_name
  identity_center_start_url = var.identity_center_start_url
  identity_center_role      = var.identity_center_role
}
