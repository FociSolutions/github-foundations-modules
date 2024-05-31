resource "github_actions_secret" "organization_managed_identity_client_id" {
  count = var.oidc_configuration.azure != null ? 1 : 0

  repository      = github_repository.organizations_repo.name
  secret_name     = coalesce(var.oidc_configuration.azure.organization_client_id_variable_name, "AZURE_CLIENT_ID")
  plaintext_value = var.oidc_configuration.azure.organization_client_id
}

resource "github_actions_secret" "bootstrap_managed_identity_client_id" {
  count = var.oidc_configuration.azure != null ? 1 : 0

  repository      = github_repository.bootstrap_repo.name
  secret_name     = coalesce(var.oidc_configuration.azure.bootstrap_client_id_variable_name, "AZURE_CLIENT_ID")
  plaintext_value = var.oidc_configuration.azure.bootstrap_client_id
}

resource "github_actions_organization_secret" "tenant_id" {
  count = var.oidc_configuration.azure != null ? 1 : 0

  secret_name     = coalesce(var.oidc_configuration.azure.tenant_id_variable_name, "AZURE_TENANT_ID")
  plaintext_value = var.oidc_configuration.azure.tenant_id
  visibility      = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "subscription_id" {
  count = var.oidc_configuration.azure != null ? 1 : 0

  variable_name     = coalesce(var.oidc_configuration.azure.subscription_id_variable_name, "AZURE_SUBSCRIPTION_ID")
  value = var.oidc_configuration.azure.subscription_id
  visibility      = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "resource_group_name" {
  count = var.oidc_configuration.azure != null ? 1 : 0

  variable_name     = coalesce(var.oidc_configuration.azure.resource_group_name_variable_name, "AZURE_RESOURCE_GROUP_NAME")
  value = var.oidc_configuration.azure.resource_group_name
  visibility      = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "storage_account_name" {
  count = var.oidc_configuration.azure != null ? 1 : 0

  variable_name     = coalesce(var.oidc_configuration.azure.storage_account_name_variable_name, "AZURE_STORAGE_ACCOUNT_NAME")
  value             = var.oidc_configuration.azure.storage_account_name
  visibility        = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "container_name" {
  count = var.oidc_configuration.azure != null ? 1 : 0

  variable_name     = coalesce(var.oidc_configuration.azure.container_name_variable_name, "AZURE_CONTAINER_NAME")
  value             = var.oidc_configuration.azure.container_name
  visibility        = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}
