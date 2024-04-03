## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |

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
| <a name="input_action_secrets"></a> [action\_secrets](#input\_action\_secrets) | An (Optional) map of GitHub Actions secrets to create for this repository. The key is the name of the secret and the value is the encrypted value. | `map(string)` | `{}` | no |
| <a name="input_advance_security"></a> [advance\_security](#input\_advance\_security) | Enables advance security for the repository. If repository is public `advance_security` is enabled by default and cannot be changed. | `bool` | `true` | no |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Allow auto-merging pull requests on the repository | `bool` | `true` | no |
| <a name="input_codespace_secrets"></a> [codespace\_secrets](#input\_codespace\_secrets) | An (Optional) map of GitHub Codespace secrets to create for this repository. The key is the name of the secret and the value is the encrypted value. | `map(string)` | `{}` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The branch to set as the default branch for this repository. Defaults to "main" | `string` | `"main"` | no |
| <a name="input_delete_head_on_merge"></a> [delete\_head\_on\_merge](#input\_delete\_head\_on\_merge) | Sets the delete head on merge option for the repository. If true it will delete pull request branches automatically on merge. Defaults to true | `bool` | `true` | no |
| <a name="input_dependabot_secrets"></a> [dependabot\_secrets](#input\_dependabot\_secrets) | An (Optional) map of Dependabot secrets to create for this repository. The key is the name of the secret and the value is the encrypted value. | `map(string)` | `{}` | no |
| <a name="input_dependabot_security_updates"></a> [dependabot\_security\_updates](#input\_dependabot\_security\_updates) | Enables dependabot security updates. Only works when `has_vulnerability_alerts` is set because that is required to enable dependabot for the repository. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description to give to the repository. Defaults to `""` | `string` | `""` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | Environments to create for the repository. | <pre>map(object({<br>    action_secrets = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_homepage"></a> [homepage](#input\_homepage) | The homepage for the repository | `string` | `""` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | The (Optional) license template to apply to the repository | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the repository to create/import. | `string` | n/a | yes |
| <a name="input_protected_branches"></a> [protected\_branches](#input\_protected\_branches) | A list of ref names or patterns that should be protected. Defaults `["main"]` | `list(string)` | <pre>[<br>  "main"<br>]</pre> | no |
| <a name="input_repository_team_permissions"></a> [repository\_team\_permissions](#input\_repository\_team\_permissions) | A map where the keys are github team slugs and the value is the permissions the team should have in the repository | `map(string)` | n/a | yes |
| <a name="input_repository_user_permissions"></a> [repository\_user\_permissions](#input\_repository\_user\_permissions) | A map where the keys are github usernames and the value is the permissions the user should have in the repository | `map(string)` | n/a | yes |
| <a name="input_requires_web_commit_signing"></a> [requires\_web\_commit\_signing](#input\_requires\_web\_commit\_signing) | If set commit signatures are required for commits to the organization. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_rulesets"></a> [rulesets](#input\_rulesets) | n/a | <pre>map(object({<br>    bypass_actors = optional(object({<br>      repository_roles = optional(list(object({<br>        role          = string<br>        always_bypass = optional(bool)<br>      })))<br>      teams = optional(list(object({<br>        team          = string<br>        always_bypass = optional(bool)<br>      })))<br>      integrations = optional(list(object({<br>        installation_id = number<br>        always_bypass   = optional(bool)<br>      })))<br>      organization_admins = optional(list(object({<br>        user          = string<br>        always_bypass = optional(bool)<br>      })))<br>    }))<br>    conditions = optional(object({<br>      ref_name = object({<br>        include = list(string)<br>        exclude = list(string)<br>      })<br>    }))<br>    rules = object({<br>      branch_name_pattern = optional(object({<br>        operator = string<br>        pattern  = string<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      tag_name_pattern = optional(object({<br>        operator = string<br>        pattern  = string<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      commit_author_email_pattern = optional(object({<br>        operator = string<br>        pattern  = string<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      commit_message_pattern = optional(object({<br>        operator = string<br>        pattern  = string<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      committer_email_pattern = optional(object({<br>        operator = string<br>        pattern  = string<br>        name     = optional(string)<br>        negate   = optional(bool)<br>      }))<br>      creation                      = optional(bool)<br>      deletion                      = optional(bool)<br>      update                        = optional(bool)<br>      non_fast_forward              = optional(bool)<br>      required_linear_history       = optional(bool)<br>      required_signatures           = optional(bool)<br>      update_allows_fetch_and_merge = optional(bool)<br>      pull_request = optional(object({<br>        dismiss_stale_reviews_on_push     = optional(bool)<br>        require_code_owner_review         = optional(bool)<br>        require_last_push_approval        = optional(bool)<br>        required_approving_review_count   = optional(number)<br>        required_review_thread_resolution = optional(bool)<br>      }))<br>      required_status_checks = optional(object({<br>        required_check = list(object({<br>          context        = string<br>          integration_id = optional(number)<br>        }))<br>        strict_required_status_check_policy = optional(bool)<br>      }))<br>      required_deployment_environments = optional(list(string))<br>    })<br>    target      = string<br>    enforcement = string<br>  }))</pre> | `{}` | no |
| <a name="input_template_repository"></a> [template\_repository](#input\_template\_repository) | A (Optional) list of template repositories to use for the repository | <pre>object({<br>    owner                = string<br>    repository           = string<br>    include_all_branches = bool<br>  })</pre> | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | The topics to apply to the repository | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the repository |