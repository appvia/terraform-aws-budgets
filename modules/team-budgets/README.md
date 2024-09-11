<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.39.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_slack_notfications"></a> [slack\_notfications](#module\_slack\_notfications) | appvia/notifications/aws | 1.0.1 |
| <a name="module_sns"></a> [sns](#module\_sns) | terraform-aws-modules/sns/aws | v6.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts_id_to_name"></a> [accounts\_id\_to\_name](#input\_accounts\_id\_to\_name) | A mapping of account id and account name - used by notification lamdba to map an account ID to a human readable name | `map(string)` | n/a | yes |
| <a name="input_budgets"></a> [budgets](#input\_budgets) | A collection of product or team budgets | <pre>list(object({<br>    amount            = number<br>    name              = string<br>    notification_type = optional(string, "ACTUAL")<br>    threshold         = optional(number, 100)<br>    threshold_type    = optional(string, "PERCENTAGE")<br>    time_unit         = optional(string, "MONTHLY")<br><br>    cost_filter = optional(list(object({<br>      name   = string<br>      values = list(string)<br>    })), [])<br><br>    cost_types = optional(object({<br>      include_credit             = optional(bool, false)<br>      include_discount           = optional(bool, false)<br>      include_other_subscription = optional(bool, false)<br>      include_recurring          = optional(bool, false)<br>      include_refund             = optional(bool, false)<br>      include_subscription       = optional(bool, false)<br>      include_support            = optional(bool, false)<br>      include_tax                = optional(bool, false)<br>      include_upfront            = optional(bool, false)<br>      use_blended                = optional(bool, false)<br>      }), {<br>      include_credit             = false<br>      include_discount           = false<br>      include_other_subscription = false<br>      include_recurring          = false<br>      include_refund             = false<br>      include_subscription       = false<br>      include_support            = false<br>      include_tax                = false<br>      include_upfront            = false<br>      use_blended                = false<br>    })<br><br>    notification = object({<br>      email = optional(object({<br>        addresses = list(string)<br>      }), null)<br>      slack = optional(object({<br>        webhook_url = string<br>      }), null)<br>      teams = optional(object({<br>        webhook_url = string<br>      }), null)<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | A SNS topic which all notifications are sent to | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->