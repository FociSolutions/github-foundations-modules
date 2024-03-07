variable "organization_action_secrets" {
  type = map(object({
    encrypted_value       = string
    visibility            = string
    selected_repositories = optional(list(string))
  }))
  description = "A map of organization github action secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visiblity is set to `selected` then `selected_repositories` must be set to a list of repositories to make the secret available."
  default     = {}
}

variable "organization_codespace_secrets" {
  type = map(object({
    encrypted_value       = string
    visibility            = string
    selected_repositories = optional(list(string))
  }))
  description = "A map of organization github codespace secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visiblity is set to `selected` then `selected_repositories` must be set to a list of repositories to make the secret available."
  default     = {}
}

variable "organization_dependabot_secrets" {
  type = map(object({
    encrypted_value       = string
    visibility            = string
    selected_repositories = optional(list(string))
  }))
  description = "A map of organization dependabot secrets to create. The key is the name of the secret and the value is an object describing how to create the secret. If visiblity is set to `selected` then `selected_repositories` must be set to a list of repositories to make the secret available."
  default     = {}
}
