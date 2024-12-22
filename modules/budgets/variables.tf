
variable "sns_topic_name" {
  description = "The name of the SNS topic to create for budget notifications"
  type        = string
  default     = "budget-notifications"
}

variable "create_sns_topic" {
  description = "A flag to determine if the SNS topic should be created"
  type        = bool
  default     = true
}

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

    cost_filter = optional(list(object({
      name   = string
      values = list(string)
    })), [])

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
    slack = optional(object({
      lambda_name = optional(string, "budget-notifications")
      secret_name = optional(string, null)
      webhook_url = optional(string, null)
    }), null)
    teams = optional(object({
      webhook_url = string
    }), null)
  })
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "accounts_id_to_name" {
  description = "A mapping of account id and account name - used by notification lamdba to map an account ID to a human readable name"
  type        = map(string)
  default     = {}
}

variable "identity_center_start_url" {
  description = "The start URL of your Identity Center instance"
  type        = string
  default     = null
}

variable "identity_center_role" {
  description = "The name of the role to use when redirecting through Identity Center"
  type        = string
  default     = null
}
