resource "github_actions_secret" "organization_workload_identity_sa" {
  count           = var.oidc_configuration.gcp != null ? 1 : 0

  repository      = github_repository.organizations_repo.name
  secret_name     = coalesce(var.oidc_configuration.gcp.organization_workload_identity_sa_secret_name, "GCP_SERVICE_ACCOUNT")
  plaintext_value = var.oidc_configuration.gcp.organization_workload_identity_sa
}

resource "github_actions_variable" "gcp_secret_manager_project_id" {
  count = var.oidc_configuration.gcp != null ? 1 : 0

  repository    = github_repository.organizations_repo.name
  variable_name = coalesce(var.oidc_configuration.gcp.gcp_secret_manager_project_id_variable_name, "GCP_SECRET_MANAGER_PROJECT")
  value         = var.oidc_configuration.gcp.gcp_secret_manager_project_id
}

resource "github_actions_organization_secret" "workload_identity_provider" {
  count = var.oidc_configuration.gcp != null ? 1 : 0

  secret_name     = coalesce(var.oidc_configuration.gcp.workload_identity_provider_name_secret_name, "WORKLOAD_IDENTITY_PROVIDER")
  plaintext_value = var.oidc_configuration.gcp.workload_identity_provider_name
  visibility      = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "tf_state_bucket_project_id" {
  count = var.oidc_configuration.gcp != null ? 1 : 0

  variable_name = coalesce(var.oidc_configuration.gcp.gcp_tf_state_bucket_project_id_variable_name, "TF_STATE_BUCKET_PROJECT_ID")
  value         = var.oidc_configuration.gcp.gcp_tf_state_bucket_project_id
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "tf_state_bucket_name" {
  count = var.oidc_configuration.gcp != null ? 1 : 0

  variable_name = coalesce(var.oidc_configuration.gcp.bucket_name_variable_name, "TF_STATE_BUCKET_NAME")
  value         = var.oidc_configuration.gcp.bucket_name
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "tf_state_bucket_location" {
  count = var.oidc_configuration.gcp != null ? 1 : 0

  variable_name = coalesce(var.oidc_configuration.gcp.bucket_location_variable_name, "TF_STATE_BUCKET_LOCATION")
  value         = var.oidc_configuration.gcp.bucket_location
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}
