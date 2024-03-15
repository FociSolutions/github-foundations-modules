## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 6.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_base_ruleset"></a> [base\_ruleset](#module\_base\_ruleset) | ../ruleset | n/a |

## Resources

| Name | Type |
|------|------|
| [github_actions_organization_secret.workload_identity_provider](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |
| [github_actions_organization_variable.tf_state_bucket_location](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_organization_variable.tf_state_bucket_name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_organization_variable.tf_state_bucket_project_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_variable) | resource |
| [github_actions_secret.organization_workload_identity_sa](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.gcp_secret_manager_project_id](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
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
| <a name="input_bootstrap_workload_identity_sa"></a> [bootstrap\_workload\_identity\_sa](#input\_bootstrap\_workload\_identity\_sa) | The service account to use for the bootstrap repository oidc. | `string` | n/a | yes |
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | The location of the tf state bucket. | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the tf state bucket. | `string` | n/a | yes |
| <a name="input_foundation_devs_team_name"></a> [foundation\_devs\_team\_name](#input\_foundation\_devs\_team\_name) | The name of the foundation developers team. | `string` | `"foundation-devs"` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The id of the gcp project where secret manager was setup. | `string` | n/a | yes |
| <a name="input_gcp_tf_state_bucket_project_id"></a> [gcp\_tf\_state\_bucket\_project\_id](#input\_gcp\_tf\_state\_bucket\_project\_id) | The id of the gcp project where the tf state bucket was setup. | `string` | n/a | yes |
| <a name="input_organization_workload_identity_sa"></a> [organization\_workload\_identity\_sa](#input\_organization\_workload\_identity\_sa) | The service account to use for the organization repository oidc. | `string` | n/a | yes |
| <a name="input_organizations_repository_name"></a> [organizations\_repository\_name](#input\_organizations\_repository\_name) | The name of the organizations repository. | `string` | `"organizations"` | no |
| <a name="input_readme_path"></a> [readme\_path](#input\_readme\_path) | Local Path to the README file in your current codebase. Pushed to the github foundation repository. | `string` | `""` | no |
| <a name="input_workload_identity_provider_name"></a> [workload\_identity\_provider\_name](#input\_workload\_identity\_provider\_name) | The name of the workload identity provider to use for the oidc of the github foundation repositories. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_foundation_dev_team_id"></a> [foundation\_dev\_team\_id](#output\_foundation\_dev\_team\_id) | n/a |