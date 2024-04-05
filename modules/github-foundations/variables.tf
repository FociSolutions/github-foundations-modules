variable "readme_path" {
  type        = string
  description = "Local Path to the README file in your current codebase. Pushed to the github foundation repository."
  default     = ""
}

variable "bootstrap_repository_name" {
  type        = string
  description = "The name of the bootstrap repository."
  default     = "bootstrap"
}

variable "organizations_repository_name" {
  type        = string
  description = "The name of the organizations repository."
  default     = "organizations"
}

variable "foundation_devs_team_name" {
  type        = string
  description = "The name of the foundation developers team."
  default     = "foundation-devs"
}

variable "oidc_configuration" {
  type = object({
    gcp = optional(object({
      workload_identity_provider_name_secret_name = optional(string)
      workload_identity_provider_name             = string

      organization_workload_identity_sa_secret_name = optional(string)
      organization_workload_identity_sa             = string

      gcp_secret_manager_project_id_variable_name = optional(string)
      gcp_secret_manager_project_id               = string

      gcp_tf_state_bucket_project_id_variable_name = optional(string)
      gcp_tf_state_bucket_project_id               = string

      bucket_name_variable_name = optional(string)
      bucket_name               = string

      bucket_location_variable_name = optional(string)
      bucket_location               = string
    }))
    custom = optional(object({
      organization_secrets   = map(string)
      organization_variables = map(string)
      repository_secrets     = map(map(string))
      repository_variables   = map(map(string))
    }))
  })
  validation {
    condition     = var.oidc_configuration.gcp != null || var.oidc_configuration.custom != null
    error_message = "At least one oidc_configuration must be set."
  }
}
