variable "private_repositories" {
  type = map(object({
    description                          = string
    default_branch                       = string
    repository_team_permissions_override = map(string)
    protected_branches                   = list(string)
    advance_security                     = bool
    has_vulnerability_alerts             = bool
    topics                               = list(string)
    homepage                             = string
    delete_head_on_merge                 = bool
    allow_auto_merge                     = bool
    dependabot_security_updates          = bool
    organization_action_secrets          = optional(list(string))
    organization_codespace_secrets       = optional(list(string))
    organization_dependabot_secrets      = optional(list(string))
    action_secrets                       = optional(map(string))
    codespace_secrets                    = optional(map(string))
    dependabot_secrets                   = optional(map(string))
    environments = optional(map(object({
      action_secrets = optional(map(string))
    })))
    template_repository = optional(object({
      owner                = string
      repository           = string
      include_all_branches = bool
    }))
    license_template = optional(string)
  }))
  description = "A map of private repositories where the key is the repository name and the value is the configuration"
}

variable "public_repositories" {
  type = map(object({
    description                          = string
    default_branch                       = string
    repository_team_permissions_override = map(string)
    protected_branches                   = list(string)
    advance_security                     = bool
    topics                               = list(string)
    homepage                             = string
    delete_head_on_merge                 = bool
    allow_auto_merge                     = bool
    dependabot_security_updates          = bool
    organization_action_secrets          = optional(list(string))
    organization_codespace_secrets       = optional(list(string))
    organization_dependabot_secrets      = optional(list(string))
    action_secrets                       = optional(map(string))
    codespace_secrets                    = optional(map(string))
    dependabot_secrets                   = optional(map(string))
    environments = optional(map(object({
      action_secrets = optional(map(string))
    })))
    template_repository = optional(object({
      owner                = string
      repository           = string
      include_all_branches = bool
    }))
    license_template = optional(string)
  }))
  description = "A map of public repositories where the key is the repository name and the value is the configuration"
}

variable "default_repository_team_permissions" {
  type        = map(string)
  description = "A map where the keys are github team slugs and the value is the permissions the team should have by default for every repository. If an entry exists in `repository_team_permissions_override` for a repository then that will take precedence over this default."
}

variable "rulesets" {
  type = map(object({
    bypass_actors = optional(object({
      repository_roles = optional(list(object({
        role          = string
        always_bypass = optional(bool)
      })))
      teams = optional(list(object({
        team          = string
        always_bypass = optional(bool)
      })))
      integrations = optional(list(object({
        installation_id = number
        always_bypass   = optional(bool)
      })))
      organization_admins = optional(list(object({
        user          = string
        always_bypass = optional(bool)
      })))
    }))
    conditions = optional(object({
      ref_name = object({
        include = list(string)
        exclude = list(string)
      })
    }))
    rules = object({
      branch_name_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))
      tag_name_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))
      commit_author_email_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))
      commit_message_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))
      committer_email_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string)
        negate   = optional(bool)
      }))
      creation                      = optional(bool)
      deletion                      = optional(bool)
      update                        = optional(bool)
      non_fast_forward              = optional(bool)
      required_linear_history       = optional(bool)
      required_signatures           = optional(bool)
      update_allows_fetch_and_merge = optional(bool)
      pull_request = optional(object({
        dismiss_stale_reviews_on_push     = optional(bool)
        require_code_owner_review         = optional(bool)
        require_last_push_approval        = optional(bool)
        required_approving_review_count   = optional(number)
        required_review_thread_resolution = optional(bool)
      }))
      required_status_checks = optional(object({
        required_check = list(object({
          context        = string
          integration_id = optional(number)
        }))
        strict_required_status_check_policy = optional(bool)
      }))
      required_deployment_environments = optional(list(string))
    })
    target       = string
    enforcement  = string
    repositories = list(string)
  }))
  default = {}
}