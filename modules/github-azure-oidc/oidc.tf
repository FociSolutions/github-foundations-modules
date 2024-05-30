locals {
  default_audience_name = "api://AzureADTokenExchange"
  github_issuer_url     = "https://token.actions.githubusercontent.com"

  bootstrap_repo_name     = "bootstrap"
  organizations_repo_name = "organizations"

  state_file_access_roles = {
    "container-${local.tf_state_container.name}-write" = {
      scope                = "${local.tf_state_container.resource_manager_id}"
      role_definition_name = "Storage Blob Data Contributor"
    },
    "storage-account-${azurerm_storage_account.github_foundations_sa.name}-contributor" = {
      scope = "${azurerm_storage_account.github_foundations_sa.id}"
      role_definition_name = "Storage Account Contributor"
    }
  }

  bootstrap_project_roles = local.state_file_access_roles

  organizations_project_roles = merge(
    local.state_file_access_roles,
    var.kv_name != "" ? {
      "keyvault-${data.azurerm_key_vault.key_vault.name}-secret-read" = {
        scope                = "${data.azurerm_key_vault.key_vault.id}"
        role_definition_name = "Key Vault Secrets User"
      }
    }: {},
    var.kv_name != "" ? {
      "keyvault-${data.azurerm_key_vault.key_vault.name}-vault-read" = {
        scope                = "${data.azurerm_key_vault.key_vault.id}"
        role_definition_name = "Key Vault Reader"
      }
    }: {}
  )
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "key_vault" {
  count =  var.kv_name != "" ? 1 : 0
  name                = var.kv_name
  resource_group_name = var.kv_resource_group != "" ? var.kv_resource_group : local.github_foundations_rg.name
}

/**
* User assigned identities and roles for github state bucket and federated identity setup
*/

resource "azurerm_user_assigned_identity" "bootstrap_identity" {
  location            = local.github_foundations_rg.location
  resource_group_name = local.github_foundations_rg.name
  name                = "${local.bootstrap_repo_name}-identity"
}

resource "azurerm_role_assignment" "bootstrap_role_assignment" {
  for_each             = local.bootstrap_project_roles
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.bootstrap_identity.principal_id
}

resource "azurerm_user_assigned_identity" "organization_identity" {
  location            = local.github_foundations_rg.location
  resource_group_name = local.github_foundations_rg.name
  name                = "${local.organizations_repo_name}-identity"
}

resource "azurerm_role_assignment" "organization_role_assignment" {
  for_each             = local.organizations_project_roles
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.organization_identity.principal_id
}

resource "azurerm_federated_identity_credential" "bootstrap_pull_request_credentials" {
  name                = "${var.github_foundations_organization_name}-${local.bootstrap_repo_name}-pr-credentials"
  resource_group_name = local.github_foundations_rg.name
  audience            = [local.default_audience_name]
  issuer              = local.github_issuer_url
  parent_id           = azurerm_user_assigned_identity.bootstrap_identity.id
  subject             = "repo:${var.github_foundations_organization_name}/${local.bootstrap_repo_name}:pull_request"
}

resource "azurerm_federated_identity_credential" "bootstrap_drift_credentials" {
  name                = "${var.github_foundations_organization_name}-${local.bootstrap_repo_name}-drift-credentials"
  resource_group_name = local.github_foundations_rg.name
  audience            = [local.default_audience_name]
  issuer              = local.github_issuer_url
  parent_id           = azurerm_user_assigned_identity.bootstrap_identity.id
  subject             = "repo:${var.github_foundations_organization_name}/${local.bootstrap_repo_name}:ref:refs/heads/${var.drift_detection_branch_name}"
}

resource "azurerm_federated_identity_credential" "organization_pull_request_credentials" {
  name                = "${var.github_foundations_organization_name}-${local.organizations_repo_name}-pr-credentials"
  resource_group_name = local.github_foundations_rg.name
  audience            = [local.default_audience_name]
  issuer              = local.github_issuer_url
  parent_id           = azurerm_user_assigned_identity.organization_identity.id
  subject             = "repo:${var.github_foundations_organization_name}/${local.organizations_repo_name}:pull_request"
}

resource "azurerm_federated_identity_credential" "organization_drift_credentials" {
  name                = "${var.github_foundations_organization_name}-${local.organizations_repo_name}-drift-credentials"
  resource_group_name = local.github_foundations_rg.name
  audience            = [local.default_audience_name]
  issuer              = local.github_issuer_url
  parent_id           = azurerm_user_assigned_identity.organization_identity.id
  subject             = "repo:${var.github_foundations_organization_name}/${local.organizations_repo_name}:ref:refs/heads/${var.drift_detection_branch_name}"
}
