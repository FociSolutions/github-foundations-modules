variable "organization_action_secrets" {
  type = map(object({
    encrypted_value       = string
    visibility            = string
    selected_repositories = optional(list(string))
  }))
  description = "A map of organization-level GitHub action secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visibility is set to `selected` then `selected_repositories` must be set to a list of repository names to make the secret available."
  default     = {}
}

variable "organization_codespace_secrets" {
  type = map(object({
    encrypted_value       = string
    visibility            = string
    selected_repositories = optional(list(string))
  }))
  description = "A map of organization-level GitHub codespace secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visibility is set to `selected` then `selected_repositories` must be set to a list of repository names to make the secret available."
  default     = {}
}

variable "organization_dependabot_secrets" {
  type = map(object({
    encrypted_value       = string
    visibility            = string
    selected_repositories = optional(list(string))
  }))
  description = "A map of organization-level dependabot secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visibility is set to `selected` then `selected_repositories` must be set to a list of repository names to make the secret available."
  default     = {}
}
