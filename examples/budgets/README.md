<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_budgets"></a> [budgets](#module\_budgets) | ../../modules/budgets | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_budgets"></a> [budgets](#input\_budgets) | A collection of budgets to provision | <pre>list(object({<br/>    name         = string<br/>    budget_type  = optional(string, "COST")<br/>    limit_amount = optional(string, "100.0")<br/>    limit_unit   = optional(string, "PERCENTAGE")<br/>    time_unit    = optional(string, "MONTHLY")<br/><br/>    notification = optional(object({<br/>      comparison_operator = string<br/>      threshold           = number<br/>      threshold_type      = string<br/>      notification_type   = string<br/>    }), null)<br/><br/>    auto_adjust_data = optional(list(object({<br/>      auto_adjust_type = string<br/>    })), [])<br/><br/>    cost_filter = optional(list(object({<br/>      name   = string<br/>      values = list(string)<br/>    })), [])<br/><br/>    cost_types = optional(object({<br/>      include_credit             = optional(bool, false)<br/>      include_discount           = optional(bool, false)<br/>      include_other_subscription = optional(bool, false)<br/>      include_recurring          = optional(bool, false)<br/>      include_refund             = optional(bool, false)<br/>      include_subscription       = optional(bool, false)<br/>      include_support            = optional(bool, false)<br/>      include_tax                = optional(bool, false)<br/>      include_upfront            = optional(bool, false)<br/>      use_blended                = optional(bool, false)<br/>      }), {<br/>      include_credit             = false<br/>      include_discount           = false<br/>      include_other_subscription = false<br/>      include_recurring          = false<br/>      include_refund             = false<br/>      include_subscription       = true<br/>      include_support            = false<br/>      include_tax                = false<br/>      include_upfront            = false<br/>      use_blended                = false<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_notification_emails"></a> [notification\_emails](#input\_notification\_emails) | A list of email addresses to notify when a budget exceeds its threshold | `list(string)` | `[]` | no |
| <a name="input_notification_secret_name"></a> [notification\_secret\_name](#input\_notification\_secret\_name) | The name of the secret containing the email address to notify when a budget exceeds its threshold | `string` | `"notification/secret"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->