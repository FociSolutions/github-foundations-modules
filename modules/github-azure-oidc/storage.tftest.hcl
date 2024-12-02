mock_provider "github" {}
mock_provider "azurerm" {
  # We need to mock the azurerm provider to avoid creating real resources
  override_resource {
    target = azurerm_user_assigned_identity.organization_identity
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/github-foundations/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ghf-organizations-identity"
    }
  }
  override_resource {
    target = azurerm_user_assigned_identity.bootstrap_identity
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/github-foundations/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ghf-bootstrap-identity"
    }
  }
  override_resource {
    target = azurerm_storage_account.github_foundations_sa
    values = {
      name = "ghfoundations"
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/github-foundations/providers/Microsoft.Storage/storageAccounts/ghfoundations"
    }
  }
}

override_data {
  target = data.azurerm_key_vault.key_vault[0]
  values = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kvrg/providers/Microsoft.KeyVault/vaults/awesome-possum"
  }
}
override_resource {
  target = azurerm_storage_container.github_foundations_tf_state_container[0]
  values = {
    resource_manager_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/github-foundations/providers/Microsoft.Storage/storageAccounts/ghfoundations/blobServices/default/containers/ghf-state"
  }
}
override_resource {
  target = azurerm_storage_container.github_foundations_tf_state_encrypted_container[0]
  values = {
    resource_manager_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/github-foundations/providers/Microsoft.Storage/storageAccounts/ghfoundations/blobServices/default/containers/ghf-state"
  }
}

variables {
  # required variables
  github_foundations_organization_name = "github-foundations"
  rg_name                              = "github-foundations"
  rg_location                          = "eastus"
  sa_name                              = "ghfoundations"
  drift_detection_branch_name          = "drift-test-branch"
  kv_resource_group                    = "kvrg"

  # variables for this test
  sa_tier                                              = "Premium"
  sa_replication_type                                  = "LRS"
  tf_state_container                                   = "ghf-state"
  tf_state_container_anonymous_access_level            = "container"
  tf_state_container_encryption_scope_override_enabled = true
  tf_state_container_default_encryption_scope = {
    name             = "defaultEncryptionScope"
    source           = "Microsoft.Storage"
    key_vault_key_id = "https://myvault.vault.azure.net/secrets/mysecret"
  }
  kv_name                 = "awesome-possum"
  organizations_repo_name = "ghf-organizations"
  bootstrap_repo_name     = "ghf-bootstrap"
}

run "github_foundations_sa_test" {
  command = apply

  assert {
    condition     = azurerm_storage_account.github_foundations_sa.resource_group_name == var.rg_name
    error_message = "The storage account resource group name is incorrect. Expected ${var.rg_name} but got ${azurerm_storage_account.github_foundations_sa.resource_group_name}."
  }
  assert {
    condition     = azurerm_storage_account.github_foundations_sa.location == var.rg_location
    error_message = "The storage account location is incorrect. Expected ${var.rg_location} but got ${azurerm_storage_account.github_foundations_sa.location}."
  }
  assert {
    condition     = azurerm_storage_account.github_foundations_sa.account_tier == var.sa_tier
    error_message = "The storage account tier is incorrect. Expected ${var.sa_tier} but got ${azurerm_storage_account.github_foundations_sa.account_tier}."
  }
  assert {
    condition     = azurerm_storage_account.github_foundations_sa.account_replication_type == var.sa_replication_type
    error_message = "The storage account replication type is incorrect. Expected ${var.sa_replication_type} but got ${azurerm_storage_account.github_foundations_sa.account_replication_type}."
  }
  assert {
    condition     = azurerm_storage_account.github_foundations_sa.min_tls_version == "TLS1_2"
    error_message = "The storage account min tls version is incorrect. Expected TLS1_2 but got ${azurerm_storage_account.github_foundations_sa.min_tls_version}."
  }
}

run "encryption_scope_test" {

  assert {
    condition     = azurerm_storage_container.github_foundations_tf_state_encrypted_container[0] != null
    error_message = "The custom encryption scope is not set."
  }
  assert {
    condition     = length(azurerm_storage_container.github_foundations_tf_state_container) == 0
    error_message = "The default encryption scope should not be set."
  }
  assert {
    condition     = azurerm_storage_encryption_scope.encryption_scope[0].name == var.tf_state_container_default_encryption_scope.name
    error_message = "The encryption scope name is incorrect. Expected ${var.tf_state_container_default_encryption_scope.name} but got ${azurerm_storage_encryption_scope.encryption_scope[0].name}."
  }
  assert {
    condition     = azurerm_storage_encryption_scope.encryption_scope[0].storage_account_id == azurerm_storage_account.github_foundations_sa.id
    error_message = "The encryption scope storage account id is incorrect. Expected ${azurerm_storage_account.github_foundations_sa.id} but got ${azurerm_storage_encryption_scope.encryption_scope[0].storage_account_id}."
  }
  assert {
    condition     = azurerm_storage_encryption_scope.encryption_scope[0].source == var.tf_state_container_default_encryption_scope.source
    error_message = "The encryption scope source is incorrect. Expected ${var.tf_state_container_default_encryption_scope.source} but got ${azurerm_storage_encryption_scope.encryption_scope[0].source}."
  }
  assert {
    condition     = azurerm_storage_encryption_scope.encryption_scope[0].key_vault_key_id == var.tf_state_container_default_encryption_scope.key_vault_key_id
    error_message = "The encryption scope key vault key id is incorrect. Expected ${var.tf_state_container_default_encryption_scope.key_vault_key_id} but got ${azurerm_storage_encryption_scope.encryption_scope[0].key_vault_key_id}."
  }
  # Check the state container configuration
  assert {
    condition     = azurerm_storage_container.github_foundations_tf_state_encrypted_container[0].name == var.tf_state_container
    error_message = "The custom encryption scope container name is incorrect. Expected ${var.tf_state_container} but got ${azurerm_storage_container.github_foundations_tf_state_encrypted_container[0].name}."
  }
  assert {
    condition     = azurerm_storage_container.github_foundations_tf_state_encrypted_container[0].container_access_type == var.tf_state_container_anonymous_access_level
    error_message = "The custom encryption scope container access type is incorrect. Expected ${var.tf_state_container_anonymous_access_level} but got ${azurerm_storage_container.github_foundations_tf_state_encrypted_container[0].container_access_type}."
  }
}

run "default_encryption_scope_test" {
  variables {
    tf_state_container_default_encryption_scope = {
      name             = ""
      source           = ""
      key_vault_key_id = ""
    }
  }

  command = apply
  plan_options {
    refresh = true
  }
  assert {
    condition     = azurerm_storage_container.github_foundations_tf_state_container[0] != null
    error_message = "The default encryption scope is not set."
  }
  assert {
    condition     = length(azurerm_storage_container.github_foundations_tf_state_encrypted_container) == 0
    error_message = "The custom encryption scope should not be set."
  }
  assert {
    condition     = length(azurerm_storage_encryption_scope.encryption_scope) == 0
    error_message = "The encryption scope should not be set."
  }
  assert {
    condition     = azurerm_storage_container.github_foundations_tf_state_container[0].name == var.tf_state_container
    error_message = "The default encryption scope container name is incorrect. Expected ${var.tf_state_container} but got ${azurerm_storage_container.github_foundations_tf_state_container[0].name}."
  }
  assert {
    condition     = azurerm_storage_container.github_foundations_tf_state_container[0].container_access_type == var.tf_state_container_anonymous_access_level
    error_message = "The default encryption scope container access type is incorrect. Expected ${var.tf_state_container_anonymous_access_level} but got ${azurerm_storage_container.github_foundations_tf_state_container[0].container_access_type}."
  }
}


# run "default_encryption_scope_test" {
#     override_data {
#         target = data.azurerm_key_vault.key_vault[0]
#         values = {
#             id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kvrg/providers/Microsoft.KeyVault/vaults/awesome-possum"
#         }
#     }
# }
