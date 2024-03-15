variable "name" {
  type        = string
  description = "The name of the repository to create/import."
}

variable "description" {
  type        = string
  description = "The description to give to the repository. Defaults to `\"\"`"
  default     = ""
}

variable "default_branch" {
  type        = string
  description = "The branch to set as the default branch for this repository. Defaults to \"main\""
  default     = "main"
}

variable "repository_team_permissions" {
  type        = map(string)
  description = "A map where the keys are github team slugs and the value is the permissions the team should have in the repository"
}

variable "protected_branches" {
  type        = list(string)
  description = "A list of ref names or patterns that should be protected. Defaults `[\"main\"]`"
  default     = ["main"]
}

variable "topics" {
  description = "The topics to apply to the repository"
  type        = list(string)
  default     = []
}

variable "homepage" {
  description = "The homepage for the repository"
  type        = string
  default     = ""
}

variable "delete_head_on_merge" {
  description = "Sets the delete head on merge option for the repository. If true it will delete pull request branches automatically on merge. Defaults to true"
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto-merging pull requests on the repository"
  type        = bool
  default     = true
}

variable "requires_web_commit_signing" {
  description = "If set commit signatures are required for commits to the organization. Defaults to `false`."
  type        = bool
  default     = false
}

variable "dependabot_security_updates" {
  description = "Enables dependabot security updates. Only works when `has_vulnerability_alerts` is set because that is required to enable dependabot for the repository."
  type        = bool
  default     = true
}

variable "advance_security" {
  description = "Enables advance security for the repository. If repository is public `advance_security` is enabled by default and cannot be changed."
  type        = bool
  default     = true
}

variable "action_secrets" {
  description = "An (Optional) map of GitHub Actions secrets to create for this repository. The key is the name of the secret and the value is the encrypted value."
  type        = map(string)
  default     = {}
}

variable "codespace_secrets" {
  description = "An (Optional) map of Github Codespace secrets to create for this repository. The key is the name of the secret and the value is the encrypted value."
  type        = map(string)
  default     = {}
}

variable "dependabot_secrets" {
  description = "An (Optional) map of Dependabot secrets to create for this repository. The key is the name of the secret and the value is the encrypted value."
  type        = map(string)
  default     = {}
}

variable "environments" {
  description = "Environments to create for the repository."
  type = map(object({
    action_secrets = optional(map(string))
  }))
  default = {}
}

variable "template_repository" {
  description = "A (Optional) list of template repositories to use for the repository"
  type = object({
    owner                = string
    repository           = string
    include_all_branches = bool
  })
  default = null
}

variable "license_template" {
  description = "The (Optional) license template to use for the repository"
  type        = string
  default     = null
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
    target      = string
    enforcement = string
  }))
  default = {}
}
