#
## Inputs to the module 
#

variable "sns_topic_arn" {
  description = "A SNS topic which all notifications are sent to"
  type        = string
  default     = ""
}

variable "budgets" {
  description = "A collection of product or team budgets"
  type = list(object({
    amount            = number
    name              = string
    notification_type = optional(string, "ACTUAL")
    threshold         = optional(number, 100)
    threshold_type    = optional(string, "PERCENTAGE")
    time_unit         = optional(string, "MONTHLY")

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
      include_subscription       = false
      include_support            = false
      include_tax                = false
      include_upfront            = false
      use_blended                = false
    })

    notification = object({
      email = optional(object({
        addresses = list(string)
      }), null)
      slack = optional(object({
        webhook_url = string
      }), null)
      teams = optional(object({
        webhook_url = string
      }), null)
    })
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "enable_slack" {
  description = "Enable/disable the posting of notifications to slack"
  type        = bool
  default     = true
}

variable "accounts_id_to_name" {
  description = "A mapping of account id and account name - used by notification lamdba to map an account ID to a human readable name"
  type        = map(string)
}
