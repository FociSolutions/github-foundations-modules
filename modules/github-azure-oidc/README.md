## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 3.77 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.bootstrap_drift_credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_federated_identity_credential.bootstrap_pull_request_credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_federated_identity_credential.organization_drift_credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_federated_identity_credential.organization_pull_request_credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_resource_group.github_foundations_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.bootstrap_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.organization_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.github_foundations_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.github_foundations_tf_state_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.github_foundations_tf_state_encrypted_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_encryption_scope.encryption_scope](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_encryption_scope) | resource |
| [azurerm_user_assigned_identity.bootstrap_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.organization_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.github_foundations_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_drift_detection_branch_name"></a> [drift\_detection\_branch\_name](#input\_drift\_detection\_branch\_name) | The name of the branch to use for drift detection. | `string` | n/a | yes |
| <a name="input_github_foundations_organization_name"></a> [github\_foundations\_organization\_name](#input\_github\_foundations\_organization\_name) | The name of the organization that the github foundation repos will be under. | `string` | n/a | yes |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | The name of the key vault to use for github foundation secrets. | `string` | n/a | yes |
| <a name="input_kv_resource_group"></a> [kv\_resource\_group](#input\_kv\_resource\_group) | The name of the resource group that the key vault is in. If empty it will default to the github foundations resource group. | `string` | n/a | yes |
| <a name="input_rg_create"></a> [rg\_create](#input\_rg\_create) | Create resource group. When set to false, uses id to reference an existing resource group. | `bool` | `true` | no |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | The location of the resource group to create the github foundation azure resources in. | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group to create the github foundation azure resources in. | `string` | n/a | yes |
| <a name="input_sa_name"></a> [sa\_name](#input\_sa\_name) | The name of the storage account for github foundations. | `string` | n/a | yes |
| <a name="input_sa_replication_type"></a> [sa\_replication\_type](#input\_sa\_replication\_type) | The replication type of the storage account for github foundations. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RA\_GZRS. | `string` | n/a | yes |
| <a name="input_sa_tier"></a> [sa\_tier](#input\_sa\_tier) | The tier of the storage account for github foundations. Valid options are Standard and Premium. | `string` | n/a | yes |
| <a name="input_tf_state_container"></a> [tf\_state\_container](#input\_tf\_state\_container) | The name of the container to store the terraform state file(s) in. | `string` | `"tfstate"` | no |
| <a name="input_tf_state_container_anonymous_access_level"></a> [tf\_state\_container\_anonymous\_access\_level](#input\_tf\_state\_container\_anonymous\_access\_level) | The anonymous access level of the container to store the terraform state file(s) in. | `string` | `"private"` | no |
| <a name="input_tf_state_container_default_encryption_scope"></a> [tf\_state\_container\_default\_encryption\_scope](#input\_tf\_state\_container\_default\_encryption\_scope) | The default encryption scope of the container to store the terraform state file(s) in. | <pre>object({<br>    name             = string<br>    source           = string<br>    key_vault_key_id = optional(string)<br>  })</pre> | <pre>{<br>  "name": "",<br>  "source": "",<br>  "storage_account_id": ""<br>}</pre> | no |
| <a name="input_tf_state_container_encryption_scope_override_enabled"></a> [tf\_state\_container\_encryption\_scope\_override\_enabled](#input\_tf\_state\_container\_encryption\_scope\_override\_enabled) | Whether or not the encryption scope override is enabled for the container to store the terraform state file(s) in. Defaults to false | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_client_id"></a> [bootstrap\_client\_id](#output\_bootstrap\_client\_id) | Bootstrap repository client id for authenticating with oidc. |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | Terraform state container name. |
| <a name="output_organization_client_id"></a> [organization\_client\_id](#output\_organization\_client\_id) | Organizations repository client id for authenticating with oidc. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | Resource group name. |
| <a name="output_sa_name"></a> [sa\_name](#output\_sa\_name) | Terraform state container storage account name. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Azure subscription id for authenticating with oidc. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | Azure tenant id for authenticating with oidc. |