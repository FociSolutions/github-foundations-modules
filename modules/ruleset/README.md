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
| [github_organization_ruleset.ruleset](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_ruleset) | resource |
| [github_repository_ruleset.ruleset](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bypass_actors"></a> [bypass\_actors](#input\_bypass\_actors) | An object containing fields for role, team, organization admin, and integration bypass actors. Defaults to `{}` | <pre>object({<br>    repository_roles = optional(list(object({<br>      role_id       = string<br>      always_bypass = optional(bool)<br>    })))<br>    teams = optional(list(object({<br>      team_id       = string<br>      always_bypass = optional(bool)<br>    })))<br>    integrations = optional(list(object({<br>      installation_id = number<br>      always_bypass   = optional(bool)<br>    })))<br>    organization_admins = optional(list(object({<br>      user_id       = string<br>      always_bypass = optional(bool)<br>    })))<br>  })</pre> | `{}` | no |
| <a name="input_enforcement"></a> [enforcement](#input\_enforcement) | The enforcement level of the ruleset. Should be one of either `active`, `evaluate` or `disabled`. Defaults to `active` | `string` | `"active"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the ruleset. | `string` | n/a | yes |
| <a name="input_ref_name_exclusions"></a> [ref\_name\_exclusions](#input\_ref\_name\_exclusions) | A list of ref names or patterns to exclude. Defaults to an empty list. If set and `ruleset_type` is set to `organization` then either `repository_name_inclusions` or `repository_name_exclusions` must be set to a list of atleast 1 string. | `list(string)` | `[]` | no |
| <a name="input_ref_name_inclusions"></a> [ref\_name\_inclusions](#input\_ref\_name\_inclusions) | A list of ref names or patterns to include. Defaults to an empty list. If set and `ruleset_type` is set to `organization` then either `repository_name_inclusions` or `repository_name_exclusions` must be set to a list of atleast 1 string. | `list(string)` | `[]` | no |
| <a name="input_repository_name_exclusions"></a> [repository\_name\_exclusions](#input\_repository\_name\_exclusions) | A list of repository names or patterns to exclude. If `ruleset_type` is set to `repository` then this field is ignored. | `list(string)` | `[]` | no |
| <a name="input_repository_name_inclusions"></a> [repository\_name\_inclusions](#input\_repository\_name\_inclusions) | A list of repository names or patterns to include. If `ruleset_type` is set to `repository` then this field is ignored. | `list(string)` | `[]` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | An object containing fields for all the rule definitions the ruleset should enforce. | <pre>object({<br>    branch_name_pattern = optional(object({<br>      operator = string<br>      pattern  = string<br>      name     = optional(string)<br>      negate   = optional(bool)<br>    }))<br>    tag_name_pattern = optional(object({<br>      operator = string<br>      pattern  = string<br>      name     = optional(string)<br>      negate   = optional(bool)<br>    }))<br>    commit_author_email_pattern = optional(object({<br>      operator = string<br>      pattern  = string<br>      name     = optional(string)<br>      negate   = optional(bool)<br>    }))<br>    commit_message_pattern = optional(object({<br>      operator = string<br>      pattern  = string<br>      name     = optional(string)<br>      negate   = optional(bool)<br>    }))<br>    committer_email_pattern = optional(object({<br>      operator = string<br>      pattern  = string<br>      name     = optional(string)<br>      negate   = optional(bool)<br>    }))<br>    creation                      = optional(bool)<br>    deletion                      = optional(bool)<br>    update                        = optional(bool)<br>    non_fast_forward              = optional(bool)<br>    required_linear_history       = optional(bool)<br>    required_signatures           = optional(bool)<br>    update_allows_fetch_and_merge = optional(bool)<br>    pull_request = optional(object({<br>      dismiss_stale_reviews_on_push     = optional(bool)<br>      require_code_owner_review         = optional(bool)<br>      require_last_push_approval        = optional(bool)<br>      required_approving_review_count   = optional(number)<br>      required_review_thread_resolution = optional(bool)<br>    }))<br>    required_status_checks = optional(object({<br>      required_check = list(object({<br>        context        = string<br>        integration_id = optional(number)<br>      }))<br>      strict_required_status_check_policy = optional(bool)<br>    }))<br>    required_workflows = optional(object({<br>      required_workflows = list(object({<br>        repository_id = number<br>        path          = string<br>        ref           = optional(string)<br>      }))<br>    }))<br>    required_deployment_environments = optional(list(string))<br>  })</pre> | n/a | yes |
| <a name="input_ruleset_type"></a> [ruleset\_type](#input\_ruleset\_type) | The type of rulset to make. Should be one of ether `organization` or `repository`. | `string` | n/a | yes |
| <a name="input_target"></a> [target](#input\_target) | The target of the ruleset. Should be one of either `branch` or `tag`. | `string` | n/a | yes |

## Outputs

No outputs.
