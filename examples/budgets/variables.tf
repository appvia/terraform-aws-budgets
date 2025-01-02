
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "notification_emails" {
  description = "A list of email addresses to notify when a budget exceeds its threshold"
  type        = list(string)
  default     = []
}

variable "notification_secret_name" {
  description = "The name of the secret containing the email address to notify when a budget exceeds its threshold"
  type        = string
  default     = "notification/secret"
}