
variable "budgets" {
  description = "A collection of budgets to provision"
  type = list(object({
    name         = string
    budget_type  = optional(string, "COST")
    limit_amount = optional(string, "100.0")
    limit_unit   = optional(string, "PERCENTAGE")
    time_unit    = optional(string, "MONTHLY")

    notification = optional(object({
      comparison_operator = string
      threshold           = number
      threshold_type      = string
      notification_type   = string
    }), null)

    auto_adjust_data = optional(list(object({
      auto_adjust_type = string
    })), [])

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

    tags = optional(map(string), {})
  }))
  default = []
}

variable "notifications" {
  description = "The configuration as to how the budget notifications should be sent"
  type = object({
    email = optional(object({
      addresses = list(string)
    }), null)
    sns = optional(object({
      topic_arn = string
    }), null)
  })
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
