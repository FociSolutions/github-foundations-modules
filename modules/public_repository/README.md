## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 5.42.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_repository_base"></a> [repository\_base](#module\_repository\_base) | ../repository_base | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_secrets"></a> [action\_secrets](#input\_action\_secrets) | An optional map of action secrets to create for this repository. The key is the name of the secret and the value is the encrypted value. | `optional(map(string))` | n/a | yes |
| <a name="input_advance_security"></a> [advance\_security](#input\_advance\_security) | Enables advance security for the repository. If repository is public `advance_security` is enabled by default and cannot be changed. | `bool` | `true` | no |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Allow auto-merging pull requests on the repository | `bool` | `true` | no |
| <a name="input_codespace_secrets"></a> [codespace\_secrets](#input\_codespace\_secrets) | An optional map of codespace secrets to create for this repository. The key is the name of the secret and the value is the encrypted value. | `optional(map(string))` | n/a | yes |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The branch to set as the default branch for this repository. Defaults to "main" | `string` | `"main"` | no |
| <a name="input_delete_head_on_merge"></a> [delete\_head\_on\_merge](#input\_delete\_head\_on\_merge) | Sets the delete head on merge option for the repository. If true it will delete pull request branches automatically on merge. Defaults to true | `bool` | `true` | no |
| <a name="input_dependabot_secrets"></a> [dependabot\_secrets](#input\_dependabot\_secrets) | An optional map of dependabot secrets to create for this repository. The key is the name of the secret and the value is the encrypted value. | `optional(map(string))` | n/a | yes |
| <a name="input_dependabot_security_updates"></a> [dependabot\_security\_updates](#input\_dependabot\_security\_updates) | Enables dependabot security updates. Only works when `has_vulnerability_alerts` is set because that is required to enable dependabot for the repository. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description to give to the repository. Defaults to `""` | `string` | `""` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | Environments to create for the repository. | <pre>map(object({<br>    action_secrets = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_homepage"></a> [homepage](#input\_homepage) | The homepage for the repository | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the repository to create/import. | `string` | n/a | yes |
| <a name="input_protected_branches"></a> [protected\_branches](#input\_protected\_branches) | A list of ref names or patterns that should be protected. Defaults `["main"]` | `list(string)` | <pre>[<br>  "main"<br>]</pre> | no |
| <a name="input_repository_team_permissions"></a> [repository\_team\_permissions](#input\_repository\_team\_permissions) | A map where the keys are github team slugs and the value is the permissions the team should have in the repository | `map(string)` | n/a | yes |
| <a name="input_topics"></a> [topics](#input\_topics) | The topics to apply to the repository | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Id of the github repository |