![Github Actions](../../actions/workflows/terraform.yml/badge.svg)

# Terraform AWS Budgets Modules

## Description

This purpose of the module is to provide a wrapper to the configuration of AWS Budgets, globally and team budgets, along with a notification optional

## Modules

- [budgets](https://github.com/appvia/terraform-aws-budgets/tree/main/modules/budgets) - This module is used to create a budget for a specific account, with the option to add a notification
- [team-budgets](https://github.com/appvia/terraform-aws-budgets/tree/main/modules/team-budgets) - This module is used to create a budget for a team, with the option to add a notification

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
