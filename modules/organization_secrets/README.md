## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 5.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 5.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_organization_secret.action_secret](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/actions_organization_secret) | resource |
| [github_codespaces_organization_secret.codespace_secret](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/codespaces_organization_secret) | resource |
| [github_dependabot_organization_secret.dependabot_secret](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/dependabot_organization_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization_action_secrets"></a> [organization\_action\_secrets](#input\_organization\_action\_secrets) | A map of organization github action secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visiblity is set to `selected` then `selected_repositories` must be set to a list of repositories to make the secret available. | <pre>map(object({<br>    encrypted_value       = string<br>    visibility            = string<br>    selected_repositories = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_organization_codespace_secrets"></a> [organization\_codespace\_secrets](#input\_organization\_codespace\_secrets) | A map of organization github codespace secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visiblity is set to `selected` then `selected_repositories` must be set to a list of repositories to make the secret available. | <pre>map(object({<br>    encrypted_value       = string<br>    visibility            = string<br>    selected_repositories = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_organization_dependabot_secrets"></a> [organization\_dependabot\_secrets](#input\_organization\_dependabot\_secrets) | A map of organization dependabot secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visiblity is set to `selected` then `selected_repositories` must be set to a list of repositories to make the secret available. | <pre>map(object({<br>    encrypted_value       = string<br>    visibility            = string<br>    selected_repositories = optional(list(string))<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.