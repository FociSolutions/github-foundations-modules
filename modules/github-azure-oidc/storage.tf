locals {
  default_encryption_scope = var.tf_state_container_default_encryption_scope.name != "" ? var.tf_state_container_default_encryption_scope : null
}

resource "azurerm_storage_account" "github_foundations_sa" {
  name                     = var.sa_name
  resource_group_name      = local.github_foundations_rg.name
  location                 = local.github_foundations_rg.location
  account_tier             = var.sa_tier
  account_replication_type = var.sa_replication_type
}

resource "azurerm_storage_encryption_scope" "encryption_scope" {
  count              = var.tf_state_container_default_encryption_scope.name != "" ? 1 : 0
  name               = var.tf_state_container_default_encryption_scope.name
  storage_account_id = azurerm_storage_account.github_foundations_sa.id
  source             = var.tf_state_container_default_encryption_scope.source
  key_vault_key_id   = var.tf_state_container_default_encryption_scope.key_vault_key_id
}

resource "azurerm_storage_container" "github_foundations_tf_state_container" {
  name                              = var.tf_state_container
  storage_account_name              = azurerm_storage_account.github_foundations_sa.name
  container_access_type             = var.tf_state_container_anonymous_access_level
  default_encryption_scope          = local.default_encryption_scope
  encryption_scope_override_enabled = var.tf_state_container_encryption_scope_override_enabled
}