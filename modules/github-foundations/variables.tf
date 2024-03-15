variable "workload_identity_provider_name" {
  type        = string
  description = "The name of the workload identity provider to use for the oidc of the github foundation repositories."
}

variable "bootstrap_workload_identity_sa" {
  type        = string
  description = "The service account to use for the bootstrap repository oidc."
}

variable "organization_workload_identity_sa" {
  type        = string
  description = "The service account to use for the organization repository oidc."
}

variable "gcp_project_id" {
  type        = string
  description = "The id of the gcp project where secret manager was setup."

}

variable "gcp_tf_state_bucket_project_id" {
  type        = string
  description = "The id of the gcp project where the tf state bucket was setup."
}

variable "bucket_name" {
  type        = string
  description = "The name of the tf state bucket."
}

variable "bucket_location" {
  type        = string
  description = "The location of the tf state bucket."
}

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