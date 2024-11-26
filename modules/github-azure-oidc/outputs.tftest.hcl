mock_provider "github" {}
mock_provider "azurerm" {
  # We need to mock the azurerm provider to avoid creating real resources
  override_resource {
    target = azurerm_user_assigned_identity.organization_identity
    values = {
      id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/github-foundations/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ghf-organizations-identity"
      client_id = "00000000-0000-0000-0000-000000000000"
    }
  }
  override_resource {
    target = azurerm_user_assigned_identity.bootstrap_identity
    values = {
      id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/github-foundations/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ghf-bootstrap-identity"
      client_id = "11111111-1111-1111-1111-111111111111"
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
override_data {
  target = data.azurerm_client_config.current
  values = {
    tenant_id       = "33333333-3333-3333-3333-333333333333"
    subscription_id = "44444444-4444-4444-4444-444444444444"
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
  sa_name                              = "ghfoundationssa"
  drift_detection_branch_name          = "drift-test-branch"
  kv_resource_group                    = "kvrg"

  # variables for this test
  tf_state_container = "ghf-state-container"
  kv_name            = "awesome-possum"
}

run "create_test" {
  command = apply

  assert {
    condition     = output.resource_group == var.rg_name
    error_message = "Resource group name does not match. Expected: ${var.rg_name}, got: ${output.resource_group}"
  }
  assert {
    condition     = output.bootstrap_client_id == "11111111-1111-1111-1111-111111111111"
    error_message = "Bootstrap repository client id does not match. Expected: 11111111-1111-1111-1111-111111111111, got: ${output.bootstrap_client_id}"
  }
  assert {
    condition     = output.organization_client_id == "00000000-0000-0000-0000-000000000000"
    error_message = "Organizations repository client id does not match. Expected: 00000000-0000-0000-0000-000000000000, got: ${output.organization_client_id}"
  }
  assert {
    condition     = output.tenant_id == "33333333-3333-3333-3333-333333333333"
    error_message = "Tenant id does not match. Expected: 33333333-3333-3333-3333-333333333333, got: ${output.tenant_id}"
  }
  assert {
    condition     = output.subscription_id == "44444444-4444-4444-4444-444444444444"
    error_message = "Subscription id does not match. Expected: 44444444-4444-4444-4444-444444444444, got: ${output.subscription_id}"
  }
  assert {
    condition     = output.sa_name == var.sa_name
    error_message = "Storage account name does not match. Expected: ${var.sa_name}, got: ${output.sa_name}"
  }
  assert {
    condition     = output.container_name == var.tf_state_container
    error_message = "Container name does not match. Expected: ${var.tf_state_container}, got: ${output.container_name}"
  }
  assert {
    condition     = output.key_vault_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kvrg/providers/Microsoft.KeyVault/vaults/awesome-possum"
    error_message = "Key vault id does not match. Expected: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kvrg/providers/Microsoft.KeyVault/vaults/awesome-possum, got: ${output.key_vault_id}"
  }
}
