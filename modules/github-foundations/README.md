## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_base_ruleset"></a> [base\_ruleset](#module\_base\_ruleset) | ../ruleset | n/a |

## Resources

| Name | Type |
|------|------|
| [github_actions_organization_secret.custom_oidc_organization_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |
| [github_actions_organization_secret.workload_identity_provider](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |
| [github_actions_organization_variable.custom_oidc_organization_variable](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_organization_variable.tf_state_bucket_location](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_organization_variable.tf_state_bucket_name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_organization_variable.tf_state_bucket_project_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_secret.organization_workload_identity_sa](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.repository_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.gcp_secret_manager_project_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_actions_variable.repository_variable](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_issue_labels.drift_labels](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_labels) | resource |
| [github_repository.bootstrap_repo](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository.organizations_repo](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_collaborators.bootstrap_repo_collaborators](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborators) | resource |
| [github_repository_collaborators.organization_repo_collaborators](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborators) | resource |
| [github_repository_file.main_readme](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_team.foundation_devs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team) | resource |
| [local_file.main_readme](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_repository_name"></a> [bootstrap\_repository\_name](#input\_bootstrap\_repository\_name) | The name of the bootstrap repository. | `string` | `"bootstrap"` | no |
| <a name="input_foundation_devs_team_name"></a> [foundation\_devs\_team\_name](#input\_foundation\_devs\_team\_name) | The name of the foundation developers team. | `string` | `"foundation-devs"` | no |
| <a name="input_oidc_configuration"></a> [oidc\_configuration](#input\_oidc\_configuration) | n/a | <pre>object({<br>    gcp = optional(object({<br>      workload_identity_provider_name_secret_name = optional(string)<br>      workload_identity_provider_name             = string<br><br>      organization_workload_identity_sa_secret_name = optional(string)<br>      organization_workload_identity_sa             = string<br><br>      gcp_secret_manager_project_id_variable_name = optional(string)<br>      gcp_secret_manager_project_id               = string<br><br>      gcp_tf_state_bucket_project_id_variable_name = optional(string)<br>      gcp_tf_state_bucket_project_id               = string<br><br>      bucket_name_variable_name = optional(string)<br>      bucket_name               = string<br><br>      bucket_location_variable_name = optional(string)<br>      bucket_location               = string<br>    }))<br>    custom = optional(object({<br>      organization_secrets   = map(string)<br>      organization_variables = map(string)<br>      repository_secrets     = map(map(string))<br>      repository_variables   = map(map(string))<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_organizations_repository_name"></a> [organizations\_repository\_name](#input\_organizations\_repository\_name) | The name of the organizations repository. | `string` | `"organizations"` | no |
| <a name="input_readme_path"></a> [readme\_path](#input\_readme\_path) | Local Path to the README file in your current codebase. Pushed to the github foundation repository. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_foundation_dev_team_id"></a> [foundation\_dev\_team\_id](#output\_foundation\_dev\_team\_id) | n/a |