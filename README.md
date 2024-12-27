<!-- markdownlint-disable -->
<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-budgets/blob/main/appvia_banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/budgets/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-budgets/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-budgets.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-budgets/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-budgets.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-budgets/actions/workflows/terraform.yml/badge.svg)

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
