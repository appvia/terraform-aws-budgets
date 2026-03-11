variable "budgets" {
  description = "A collection of budgets to provision"
  type = list(object({
    auto_adjust_data = optional(list(object({
      auto_adjust_type = string
    })), [])
    budget_type = optional(string, "COST")
    cost_filter = optional(map(object({
      values = list(string)
    })), {})
    cost_types = optional(object({
      include_credit             = optional(bool, false)
      include_discount           = optional(bool, false)
      include_other_subscription = optional(bool, false)
      include_recurring          = optional(bool, false)
      include_refund             = optional(bool, false)
      include_subscription       = optional(bool, false)
      include_support            = optional(bool, false)
      include_tax                = optional(bool, false)
      include_upfront            = optional(bool, false)
      use_blended                = optional(bool, false)
      }), {
      include_credit             = false
      include_discount           = false
      include_other_subscription = false
      include_recurring          = false
      include_refund             = false
      include_subscription       = true
      include_support            = false
      include_tax                = false
      include_upfront            = false
      use_blended                = false
    })
    limit_amount = optional(string, "100.0")
    limit_unit   = optional(string, "PERCENTAGE")
    name         = string
    notifications = optional(map(object({
      comparison_operator = string
      notification_type   = string
      threshold           = number
      threshold_type      = string
    })), {})
    tags      = optional(map(string), {})
    time_unit = optional(string, "MONTHLY")
  }))
  default = []
}

variable "notifications" {
  description = "The configuration as to how the budget notifications should be sent"
  type = object({
    # Configuration for the email notifications. If null, email notifications will not be sent.
    email = optional(object({
      # List of email addresses to send the notifications to.
      addresses = list(string)
    }), null)
    # COnfiguration for the SNS notifications. If null, SNS notifications will not be sent.
    sns = optional(object({
      # The ARN for the queue to send the notifications to.
      topic_arn = optional(string, null)
      # The name of a SNS topic to send the notifications to.
      topic_name = optional(string, null)
    }), null)
  })

  validation {
    condition = (
      var.notifications.sns == null ||
      !(
        try(var.notifications.sns.topic_arn, null) != null &&
        try(var.notifications.sns.topic_name, null) != null
      )
    )
    error_message = "Only one of notifications.sns.topic_arn or notifications.sns.topic_name can be set."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
