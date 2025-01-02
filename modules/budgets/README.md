![Github Actions](../../actions/workflows/terraform.yml/badge.svg)

# Terraform AWS Budgets Modules

## Description

This purpose of the module is to provide a wrapper to the configuration of AWS Budgets, globally and team budgets, along with a notification optional

## Usage

Add example usage here

```hcl
locals {
  budgets = [
    {
      name         = "AWS Savings Plan Coverage Budget"
      budget_type  = "SAVINGS_PLANS_COVERAGE"
      limit_amount = "100.0"
      limit_unit   = "PERCENTAGE"
      time_unit    = "MONTHLY"

      notification = {
        comparison_operator = "LESS_THAN"
        threshold           = "100"
        threshold_type      = "PERCENTAGE"
        notification_type   = "ACTUAL"
      }
    },
    {
      name         = "AWS Savings Plan Utilization Budget"
      budget_type  = "SAVINGS_PLANS_UTILIZATION"
      limit_amount = "100.0"
      limit_unit   = "PERCENTAGE"
      time_unit    = "MONTHLY"

      notification = {
        comparison_operator = "LESS_THAN"
        threshold           = "100"
        threshold_type      = "PERCENTAGE"
        notification_type   = "ACTUAL"
      }
    }
  ]
}

module "budgets" {
  source  = "../../"

  budgets = var.budgets
  notification = {
    email = {
      addresses = var.notification_emails
    }
  }
  tags = var.tags
}
```

## Notifications

You can configure the budgets to send to emails without any additional configuration. If you want to send to Slack or Teams, you will need to provide the webhook URL for the respective service. For example see below

```hcl
module "budgets" {
  source  = "../../"

  budgets = var.budgets
  notification = {
    email = {
      addresses = var.notification_emails
    },
    slack = {
      webhook_url = jsondecode(data.aws_secretsmanager_secret_version.slack.secret_string).webhook_url
    }
  }
  tags = var.tags
}
```

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_notifications"></a> [notifications](#input\_notifications) | The configuration as to how the budget notifications should be sent | <pre>object({<br/>    email = optional(object({<br/>      addresses = list(string)<br/>    }), null)<br/>    slack = optional(object({<br/>      lambda_name = optional(string, "budget-notifications")<br/>      secret_name = optional(string, null)<br/>      webhook_url = optional(string, null)<br/>    }), null)<br/>    teams = optional(object({<br/>      webhook_url = string<br/>    }), null)<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | n/a | yes |
| <a name="input_budgets"></a> [budgets](#input\_budgets) | A collection of budgets to provision | <pre>list(object({<br/>    name         = string<br/>    budget_type  = optional(string, "COST")<br/>    limit_amount = optional(string, "100.0")<br/>    limit_unit   = optional(string, "PERCENTAGE")<br/>    time_unit    = optional(string, "MONTHLY")<br/><br/>    notification = optional(object({<br/>      comparison_operator = string<br/>      threshold           = number<br/>      threshold_type      = string<br/>      notification_type   = string<br/>    }), null)<br/><br/>    auto_adjust_data = optional(list(object({<br/>      auto_adjust_type = string<br/>    })), [])<br/><br/>    cost_filter = optional(map(object({<br/>      values = list(string)<br/>    })), {})<br/><br/>    cost_types = optional(object({<br/>      include_credit             = optional(bool, false)<br/>      include_discount           = optional(bool, false)<br/>      include_other_subscription = optional(bool, false)<br/>      include_recurring          = optional(bool, false)<br/>      include_refund             = optional(bool, false)<br/>      include_subscription       = optional(bool, false)<br/>      include_support            = optional(bool, false)<br/>      include_tax                = optional(bool, false)<br/>      include_upfront            = optional(bool, false)<br/>      use_blended                = optional(bool, false)<br/>      }), {<br/>      include_credit             = false<br/>      include_discount           = false<br/>      include_other_subscription = false<br/>      include_recurring          = false<br/>      include_refund             = false<br/>      include_subscription       = true<br/>      include_support            = false<br/>      include_tax                = false<br/>      include_upfront            = false<br/>      use_blended                = false<br/>    })<br/><br/>    tags = optional(map(string), {})<br/>  }))</pre> | `[]` | no |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | A flag to determine if the SNS topic should be created | `bool` | `true` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | The name of the SNS topic to create for budget notifications | `string` | `"budget-notifications"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

```

```
