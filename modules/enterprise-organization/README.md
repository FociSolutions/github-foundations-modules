## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_enterprise_organization.organization](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/enterprise_organization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_logins"></a> [admin\_logins](#input\_admin\_logins) | List of organization owner usernames. | `list(string)` | n/a | yes |
| <a name="input_billing_email"></a> [billing\_email](#input\_billing\_email) | The email to use for the organizations billing. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of the organization. | `string` | `""` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the organization. If set to an empty string then `name` will be used instead | `string` | `""` | no |
| <a name="input_enterprise_id"></a> [enterprise\_id](#input\_enterprise\_id) | The id of the enterprise account to create the organization under. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the organization to create. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
