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
    azure = optional(object({
      bootstrap_client_id_variable_name = optional(string)
      bootstrap_client_id               = string

      organization_client_id_variable_name = optional(string)
      organization_client_id               = string

      tenant_id_variable_name = optional(string)
      tenant_id               = string

      subscription_id_variable_name = optional(string)
      subscription_id               = string

      resource_group_name_variable_name = optional(string)
      resource_group_name               = string

      storage_account_name_variable_name = optional(string)
      storage_account_name               = string

      container_name_variable_name = optional(string)
      container_name               = string

      key_vault_id_variable_name = optional(string)
      key_vault_id               = string
    }))
    aws = optional(object({
      s3_bucket_variable_name = optional(string)
      s3_bucket               = string

      region_variable_name = optional(string)
      region               = string

      organizations_role_variable_name = optional(string)
      organizations_role               = string

      dynamodb_table_variable_name = optional(string)
      dynamodb_table               = string
    }))
    custom = optional(object({
      organization_secrets   = map(string)
      organization_variables = map(string)
      repository_secrets     = map(map(string))
      repository_variables   = map(map(string))
    }))
  })
  validation {
    condition     = var.oidc_configuration.gcp != null || var.oidc_configuration.custom != null || var.oidc_configuration.azure != null || var.oidc_configuration.aws != null
    error_message = "At least one oidc_configuration must be set."
  }
}

variable "account_type" {
  type        = string
  description = "The type of GitHub account being used. Should be one of either `Personal`, `Organization`, or `Enterprise`."

  validation {
    condition     = contains(["Personal", "Organization", "Enterprise"], var.account_type)
    error_message = "The account type must be either `Personal`, `Organization`, or `Enterprise`."
  }
}
