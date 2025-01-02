<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_notification_emails"></a> [notification\_emails](#input\_notification\_emails) | A list of email addresses to notify when a budget exceeds its threshold | `list(string)` | `[]` | no |
| <a name="input_notification_secret_name"></a> [notification\_secret\_name](#input\_notification\_secret\_name) | The name of the secret containing the email address to notify when a budget exceeds its threshold | `string` | `"notification/secret"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->