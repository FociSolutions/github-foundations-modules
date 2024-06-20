## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.state_lock_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_openid_connect_provider.oidc_provider_entry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.organizations_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.organizations_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.encryption_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_resourcegroups_group.github_foundations_rg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_s3_bucket.state_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.state_bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.state_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the s3 bucket that will store terraform state. | `string` | `"GithubFoundationState"` | no |
| <a name="input_github_foundations_organization_name"></a> [github\_foundations\_organization\_name](#input\_github\_foundations\_organization\_name) | The owner of the github foundations organizations repository. This value should be whatever github account you plan to make the repository under. | `string` | n/a | yes |
| <a name="input_github_thumbprints"></a> [github\_thumbprints](#input\_github\_thumbprints) | A list of top intermediate certifact authority thumbprints to use for setting up an openid connect provider with github. Info on how to obtain thumbprints here: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html | `list(string)` | n/a | yes |
| <a name="input_organizations_repo_name"></a> [organizations\_repo\_name](#input\_organizations\_repo\_name) | The name of the github foundations organizations repository. Defaults to `organizations` | `string` | `"organizations"` | no |
| <a name="input_organizations_role_name"></a> [organizations\_role\_name](#input\_organizations\_role\_name) | The name of the role that will be assummed by the github runner for the organizations repository. | `string` | `"GhFoundationsOrganizationsAction"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the AWS resource group to create for github foundation resources. | `string` | `"GithubFoundationResources"` | no |
| <a name="input_tflock_db_billing_mode"></a> [tflock\_db\_billing\_mode](#input\_tflock\_db\_billing\_mode) | The billing mode to use for the dynamodb table storing lock file ids. Defaults to `PROVISIONED`. | `string` | `"PROVISIONED"` | no |
| <a name="input_tflock_db_name"></a> [tflock\_db\_name](#input\_tflock\_db\_name) | The name of the dynamodb table that will store lock file ids. | `string` | `"TFLockIds"` | no |
| <a name="input_tflock_db_read_capacity"></a> [tflock\_db\_read\_capacity](#input\_tflock\_db\_read\_capacity) | The read capacity to set for the dynamodb table storing lock file ids. Only required if billing mode is `PROVISIONED`. Defaults to 20. | `number` | `20` | no |
| <a name="input_tflock_db_write_capacity"></a> [tflock\_db\_write\_capacity](#input\_tflock\_db\_write\_capacity) | The write capacity to set for the dynamodb table storing lock file ids. Only required if billing mode is `PROVISIONED`. Defaults to 20. | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | The name of the dynamodb table that was created to store lock file ids. |
| <a name="output_organizations_runner_role"></a> [organizations\_runner\_role](#output\_organizations\_runner\_role) | The ARN of the role that the github action runner should assume for the organizations repo |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the s3 bucket holding terraform state. |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region) | The region the s3 bucket holding terraform state was created in. |