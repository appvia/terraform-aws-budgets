<!-- markdownlint-disable -->
<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-budgets/blob/main/appvia_banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/budgets/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-budgets/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-budgets.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-budgets/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-budgets.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-budgets/actions/workflows/terraform.yml/badge.svg)

# Terraform AWS Budgets

## Introduction

This module standardizes AWS Budget creation for account and workload cost controls, with built-in support for email and SNS notifications. It is designed as a single root module so teams can adopt a consistent budget pattern without composing multiple nested modules.

## Features

- Multi-budget provisioning in one module invocation
- Cost and usage budget support with per-budget filters and cost types
- Notification fanout to email and SNS endpoints
- SNS notification target can be configured by full ARN or by topic name
- Tagging support for organizational governance and reporting

## Usage

### Golden Path

```hcl
module "budgets" {
  source = "appvia/budgets/aws"

  budgets = [
    {
      name         = "monthly-spend"
      budget_type  = "COST"
      limit_amount = "1000"
      limit_unit   = "USD"
      time_unit    = "MONTHLY"
      notifications = {
        actual = {
          comparison_operator = "GREATER_THAN"
          threshold           = 80
          threshold_type      = "PERCENTAGE"
          notification_type   = "ACTUAL"
        }
      }
    }
  ]

  notifications = {
    email = {
      addresses = ["platform@example.com"]
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Power User

```hcl
module "budgets" {
  source = "appvia/budgets/aws"

  budgets = [
    {
      name         = "eu-west-2-forecast"
      budget_type  = "COST"
      limit_amount = "2500"
      limit_unit   = "USD"
      time_unit    = "MONTHLY"
      cost_filter = {
        Region = {
          values = ["eu-west-2"]
        }
      }
      cost_types = {
        include_credit       = false
        include_discount     = false
        include_recurring    = true
        include_refund       = false
        include_subscription = true
        include_support      = true
        include_tax          = true
        include_upfront      = true
        use_blended          = false
      }
      notifications = {
        forecast = {
          comparison_operator = "GREATER_THAN"
          threshold           = 90
          threshold_type      = "PERCENTAGE"
          notification_type   = "FORECASTED"
        }
      }
      tags = {
        CostCenter = "engineering"
      }
    }
  ]

  notifications = {
    sns = {
      topic_arn = "arn:aws:sns:eu-west-2:123456789012:budget-alerts"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Owner       = "platform"
  }
}
```

### SNS Topic Name Alternative

```hcl
module "budgets" {
  source = "appvia/budgets/aws"

  budgets = [
    {
      name         = "monthly-spend"
      budget_type  = "COST"
      limit_amount = "1000"
      limit_unit   = "USD"
      time_unit    = "MONTHLY"
      notifications = {
        actual = {
          comparison_operator = "GREATER_THAN"
          threshold           = 80
          threshold_type      = "PERCENTAGE"
          notification_type   = "ACTUAL"
        }
      }
    }
  ]

  notifications = {
    sns = {
      topic_name = "budget-alerts"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Migration

- `modules/budgets` has been moved to the repository root; update module sources from `...//modules/budgets` to `appvia/budgets/aws`.
- `modules/team-budgets` has been removed and is no longer supported.

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_notifications"></a> [notifications](#input\_notifications) | The configuration as to how the budget notifications should be sent | <pre>object({<br/>    # Configuration for the email notifications. If null, email notifications will not be sent.<br/>    email = optional(object({<br/>      # List of email addresses to send the notifications to.<br/>      addresses = list(string)<br/>    }), null)<br/>    # COnfiguration for the SNS notifications. If null, SNS notifications will not be sent.<br/>    sns = optional(object({<br/>      # The ARN for the queue to send the notifications to.<br/>      topic_arn = optional(string, null)<br/>      # The name of a SNS topic to send the notifications to.<br/>      topic_name = optional(string, null)<br/>    }), null)<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | n/a | yes |
| <a name="input_budgets"></a> [budgets](#input\_budgets) | A collection of budgets to provision | <pre>list(object({<br/>    auto_adjust_data = optional(list(object({<br/>      auto_adjust_type = string<br/>    })), [])<br/>    budget_type = optional(string, "COST")<br/>    cost_filter = optional(map(object({<br/>      values = list(string)<br/>    })), {})<br/>    cost_types = optional(object({<br/>      include_credit             = optional(bool, false)<br/>      include_discount           = optional(bool, false)<br/>      include_other_subscription = optional(bool, false)<br/>      include_recurring          = optional(bool, false)<br/>      include_refund             = optional(bool, false)<br/>      include_subscription       = optional(bool, false)<br/>      include_support            = optional(bool, false)<br/>      include_tax                = optional(bool, false)<br/>      include_upfront            = optional(bool, false)<br/>      use_blended                = optional(bool, false)<br/>      }), {<br/>      include_credit             = false<br/>      include_discount           = false<br/>      include_other_subscription = false<br/>      include_recurring          = false<br/>      include_refund             = false<br/>      include_subscription       = true<br/>      include_support            = false<br/>      include_tax                = false<br/>      include_upfront            = false<br/>      use_blended                = false<br/>    })<br/>    limit_amount = optional(string, "100.0")<br/>    limit_unit   = optional(string, "PERCENTAGE")<br/>    name         = string<br/>    notifications = optional(map(object({<br/>      comparison_operator = string<br/>      notification_type   = string<br/>      threshold           = number<br/>      threshold_type      = string<br/>    })), {})<br/>    tags      = optional(map(string), {})<br/>    time_unit = optional(string, "MONTHLY")<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budget_arns"></a> [budget\_arns](#output\_budget\_arns) | Map of budget names to budget ARNs |
| <a name="output_budget_ids"></a> [budget\_ids](#output\_budget\_ids) | Map of budget names to budget IDs |
| <a name="output_budget_names"></a> [budget\_names](#output\_budget\_names) | List of created budget names |
<!-- END_TF_DOCS -->
