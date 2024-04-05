variable "name" {
  type        = string
  description = "The name of the ruleset."
}

variable "bypass_actors" {
  type = object({
    repository_roles = optional(list(object({
      role_id       = string
      always_bypass = optional(bool)
    })))
    teams = optional(list(object({
      team_id       = string
      always_bypass = optional(bool)
    })))
    integrations = optional(list(object({
      installation_id = number
      always_bypass   = optional(bool)
    })))
    organization_admins = optional(list(object({
      user_id       = string
      always_bypass = optional(bool)
    })))
  })
  default     = {}
  description = "An object containing fields for role, team, organization admin, and integration bypass actors. Defaults to `{}`"
}

variable "rules" {
  type = object({
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
    required_workflows = optional(object({
      required_workflows = list(object({
        repository_id = number
        path          = string
        ref           = optional(string)
      }))
    }))
    required_deployment_environments = optional(list(string))
  })
  description = "An object containing fields for all the rule definitions the ruleset should enforce."
}

variable "ref_name_inclusions" {
  type        = list(string)
  description = "A list of ref names or patterns to include. Defaults to an empty list. If set and `ruleset_type` is set to `organization` then either `repository_name_inclusions` or `repository_name_exclusions` must be set to a list of atleast 1 string."
  default     = []
}

variable "ref_name_exclusions" {
  type        = list(string)
  description = "A list of ref names or patterns to exclude. Defaults to an empty list. If set and `ruleset_type` is set to `organization` then either `repository_name_inclusions` or `repository_name_exclusions` must be set to a list of atleast 1 string."
  default     = []
}

variable "repository_name_inclusions" {
  type        = list(string)
  description = "A list of repository names or patterns to include. If `ruleset_type` is set to `repository` then this field is ignored."
  default     = []
}

variable "repository_name_exclusions" {
  type        = list(string)
  description = "A list of repository names or patterns to exclude. If `ruleset_type` is set to `repository` then this field is ignored."
  default     = []
}

variable "target" {
  type        = string
  description = "The target of the ruleset. Should be one of either `branch` or `tag`."
  validation {
    condition     = can(regex("branch|tag", var.target))
    error_message = "The target must be either `branch` or `tag`."
  }
}

variable "ruleset_type" {
  type        = string
  description = "The type of rulset to make. Should be one of ether `organization` or `repository`."
  validation {
    condition     = can(regex("organization|repository", var.ruleset_type))
    error_message = "The ruleset type must be either `organization` or `repository`."
  }
}

variable "enforcement" {
  type        = string
  description = "The enforcement level of the ruleset. Should be one of either `active`, `evaluate` or `disabled`. Defaults to `active`"
  default     = "active"
  validation {
    condition     = can(regex("active|evaluate|disabled", var.enforcement))
    error_message = "The enforcement level must be either `active`, `evaluate` or `disabled`."
  }
}
