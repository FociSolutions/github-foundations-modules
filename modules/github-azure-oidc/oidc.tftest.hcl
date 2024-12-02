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

# local overrides
override_resource {
  target = azurerm_storage_container.github_foundations_tf_state_container[0]
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
  tf_state_container = "ghf-state"
  kv_name            = "awesome-possum"

}

run "bootstrap_identity_test" {
  command = apply

  assert {
    condition     = azurerm_user_assigned_identity.bootstrap_identity.location == var.rg_location
    error_message = "The location of the bootstrap identity is incorrect. Expected: ${var.rg_location}, Got: ${azurerm_user_assigned_identity.bootstrap_identity.location}"
  }
  assert {
    condition     = azurerm_user_assigned_identity.bootstrap_identity.resource_group_name == var.rg_name
    error_message = "The resource group name of the bootstrap identity is incorrect. Expected: ${var.rg_name}, Got: ${azurerm_user_assigned_identity.bootstrap_identity.resource_group_name}"
  }
  assert {
    condition     = azurerm_user_assigned_identity.bootstrap_identity.name == "${var.bootstrap_repo_name}-identity"
    error_message = "The name of the bootstrap identity is incorrect. Expected: ${var.bootstrap_repo_name}-identity, Got: ${azurerm_user_assigned_identity.bootstrap_identity.name}"
  }
}

run "bootstrap_role_assignment" {
  assert {
    condition     = azurerm_role_assignment.bootstrap_role_assignment["storage-account-ghfoundations-contributor"].scope == azurerm_storage_account.github_foundations_sa.id
    error_message = "The scope of the bootstrap role assignment is incorrect. Expected: ${azurerm_storage_account.github_foundations_sa.id}, Got: ${azurerm_role_assignment.bootstrap_role_assignment["storage-account-ghfoundations-contributor"].scope}"
  }
  assert {
    condition     = azurerm_role_assignment.bootstrap_role_assignment["storage-account-ghfoundations-contributor"].role_definition_name == "Storage Account Contributor"
    error_message = "The role definition name of the bootstrap role assignment is incorrect. Expected: Storage Account Contributor, Got: ${azurerm_role_assignment.bootstrap_role_assignment["storage-account-ghfoundations-contributor"].role_definition_name}"
  }
}

run "organization_identity_test" {
  assert {
    condition     = azurerm_user_assigned_identity.organization_identity.location == var.rg_location
    error_message = "The location of the organization identity is incorrect. Expected: ${var.rg_location}, Got: ${azurerm_user_assigned_identity.organization_identity.location}"
  }
  assert {
    condition     = azurerm_user_assigned_identity.organization_identity.resource_group_name == var.rg_name
    error_message = "The resource group name of the organization identity is incorrect. Expected: ${var.rg_name}, Got: ${azurerm_user_assigned_identity.organization_identity.resource_group_name}"
  }
  assert {
    condition     = azurerm_user_assigned_identity.organization_identity.name == "${var.organizations_repo_name}-identity"
    error_message = "The name of the organization identity is incorrect. Expected: ${var.organizations_repo_name}-identity, Got: ${azurerm_user_assigned_identity.organization_identity.name}"
  }
}

run "organization_role_assignment" {
  assert {
    condition     = azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-secret-read"].scope == data.azurerm_key_vault.key_vault[0].id
    error_message = "The scope of the organization role assignment is incorrect. Expected: ${data.azurerm_key_vault.key_vault[0].id}, Got: ${azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-secret-read"].scope}"
  }
  assert {
    condition     = azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-secret-read"].role_definition_name == "Key Vault Secrets User"
    error_message = "The role definition name of the organization role assignment is incorrect. Expected: Key Vault Secrets User, Got: ${azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-secret-read"].role_definition_name}"
  }
  assert {
    condition     = azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-vault-read"].role_definition_name == "Key Vault Reader"
    error_message = "The role definition name of the organization role assignment is incorrect. Expected: Key Vault Reader, Got: ${azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-vault-read"].role_definition_name}"
  }
  assert {
    condition     = azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-vault-read"].scope == data.azurerm_key_vault.key_vault[0].id
    error_message = "The scope of the organization role assignment is incorrect. Expected: ${data.azurerm_key_vault.key_vault[0].id}, Got: ${azurerm_role_assignment.organization_role_assignment["keyvault-${data.azurerm_key_vault.key_vault[0].name}-vault-read"].scope}"
  }
}

run "bootstrap_pull_request_credentials_test" {
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_pull_request_credentials.name == "${var.github_foundations_organization_name}-${var.bootstrap_repo_name}-pr-credentials"
    error_message = "The name of the bootstrap pull request credentials is incorrect. Expected: ${var.github_foundations_organization_name}-${var.bootstrap_repo_name}-pr-credentials, Got: ${azurerm_federated_identity_credential.bootstrap_pull_request_credentials.name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_pull_request_credentials.resource_group_name == var.rg_name
    error_message = "The resource group name of the bootstrap pull request credentials is incorrect. Expected: ${var.rg_name}, Got: ${azurerm_federated_identity_credential.bootstrap_pull_request_credentials.resource_group_name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_pull_request_credentials.audience[0] == local.default_audience_name
    error_message = "The audience of the bootstrap pull request credentials is incorrect. Expected: ${local.default_audience_name}, Got: ${azurerm_federated_identity_credential.bootstrap_pull_request_credentials.audience[0]}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_pull_request_credentials.issuer == local.github_issuer_url
    error_message = "The issuer of the bootstrap pull request credentials is incorrect. Expected: ${local.github_issuer_url}, Got: ${azurerm_federated_identity_credential.bootstrap_pull_request_credentials.issuer}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_pull_request_credentials.parent_id == azurerm_user_assigned_identity.bootstrap_identity.id
    error_message = "The parent id of the bootstrap pull request credentials is incorrect. Expected: ${azurerm_user_assigned_identity.bootstrap_identity.id}, Got: ${azurerm_federated_identity_credential.bootstrap_pull_request_credentials.parent_id}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_pull_request_credentials.subject == "repo:${var.github_foundations_organization_name}/${var.bootstrap_repo_name}:pull_request"
    error_message = "The subject of the bootstrap pull request credentials is incorrect. Expected: repo:${var.github_foundations_organization_name}/${var.bootstrap_repo_name}:pull_request, Got: ${azurerm_federated_identity_credential.bootstrap_pull_request_credentials.subject}"
  }
}

run "bootstrap_drift_credentials_test" {
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_drift_credentials.name == "${var.github_foundations_organization_name}-${var.bootstrap_repo_name}-drift-credentials"
    error_message = "The name of the bootstrap drift credentials is incorrect. Expected: ${var.github_foundations_organization_name}-${var.bootstrap_repo_name}-drift-credentials, Got: ${azurerm_federated_identity_credential.bootstrap_drift_credentials.name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_drift_credentials.resource_group_name == var.rg_name
    error_message = "The resource group name of the bootstrap drift credentials is incorrect. Expected: ${var.rg_name}, Got: ${azurerm_federated_identity_credential.bootstrap_drift_credentials.resource_group_name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_drift_credentials.audience[0] == local.default_audience_name
    error_message = "The audience of the bootstrap drift credentials is incorrect. Expected: ${local.default_audience_name}, Got: ${azurerm_federated_identity_credential.bootstrap_drift_credentials.audience[0]}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_drift_credentials.issuer == local.github_issuer_url
    error_message = "The issuer of the bootstrap drift credentials is incorrect. Expected: ${local.github_issuer_url}, Got: ${azurerm_federated_identity_credential.bootstrap_drift_credentials.issuer}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_drift_credentials.parent_id == azurerm_user_assigned_identity.bootstrap_identity.id
    error_message = "The parent id of the bootstrap drift credentials is incorrect. Expected: ${azurerm_user_assigned_identity.bootstrap_identity.id}, Got: ${azurerm_federated_identity_credential.bootstrap_drift_credentials.parent_id}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.bootstrap_drift_credentials.subject == "repo:${var.github_foundations_organization_name}/${var.bootstrap_repo_name}:ref:refs/heads/${var.drift_detection_branch_name}"
    error_message = "The subject of the bootstrap drift credentials is incorrect. Expected: repo:${var.github_foundations_organization_name}/${var.bootstrap_repo_name}:ref:refs/heads/${var.drift_detection_branch_name}, Got: ${azurerm_federated_identity_credential.bootstrap_drift_credentials.subject}"
  }
}

run "organization_pull_request_credentials_test" {
  assert {
    condition     = azurerm_federated_identity_credential.organization_pull_request_credentials.name == "${var.github_foundations_organization_name}-${var.organizations_repo_name}-pr-credentials"
    error_message = "The name of the organization pull request credentials is incorrect. Expected: ${var.github_foundations_organization_name}-${var.organizations_repo_name}-pr-credentials, Got: ${azurerm_federated_identity_credential.organization_pull_request_credentials.name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_pull_request_credentials.resource_group_name == var.rg_name
    error_message = "The resource group name of the organization pull request credentials is incorrect. Expected: ${var.rg_name}, Got: ${azurerm_federated_identity_credential.organization_pull_request_credentials.resource_group_name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_pull_request_credentials.audience[0] == local.default_audience_name
    error_message = "The audience of the organization pull request credentials is incorrect. Expected: ${local.default_audience_name}, Got: ${azurerm_federated_identity_credential.organization_pull_request_credentials.audience[0]}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_pull_request_credentials.issuer == local.github_issuer_url
    error_message = "The issuer of the organization pull request credentials is incorrect. Expected: ${local.github_issuer_url}, Got: ${azurerm_federated_identity_credential.organization_pull_request_credentials.issuer}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_pull_request_credentials.parent_id == azurerm_user_assigned_identity.organization_identity.id
    error_message = "The parent id of the organization pull request credentials is incorrect. Expected: ${azurerm_user_assigned_identity.organization_identity.id}, Got: ${azurerm_federated_identity_credential.organization_pull_request_credentials.parent_id}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_pull_request_credentials.subject == "repo:${var.github_foundations_organization_name}/${var.organizations_repo_name}:pull_request"
    error_message = "The subject of the organization pull request credentials is incorrect. Expected: repo:${var.github_foundations_organization_name}/${var.organizations_repo_name}:pull_request, Got: ${azurerm_federated_identity_credential.organization_pull_request_credentials.subject}"
  }
}

run "organization_drift_credentials_test" {
  assert {
    condition     = azurerm_federated_identity_credential.organization_drift_credentials.name == "${var.github_foundations_organization_name}-${var.organizations_repo_name}-drift-credentials"
    error_message = "The name of the organization drift credentials is incorrect. Expected: ${var.github_foundations_organization_name}-${var.organizations_repo_name}-drift-credentials, Got: ${azurerm_federated_identity_credential.organization_drift_credentials.name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_drift_credentials.resource_group_name == var.rg_name
    error_message = "The resource group name of the organization drift credentials is incorrect. Expected: ${var.rg_name}, Got: ${azurerm_federated_identity_credential.organization_drift_credentials.resource_group_name}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_drift_credentials.audience[0] == local.default_audience_name
    error_message = "The audience of the organization drift credentials is incorrect. Expected: ${local.default_audience_name}, Got: ${azurerm_federated_identity_credential.organization_drift_credentials.audience[0]}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_drift_credentials.issuer == local.github_issuer_url
    error_message = "The issuer of the organization drift credentials is incorrect. Expected: ${local.github_issuer_url}, Got: ${azurerm_federated_identity_credential.organization_drift_credentials.issuer}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_drift_credentials.parent_id == azurerm_user_assigned_identity.organization_identity.id
    error_message = "The parent id of the organization drift credentials is incorrect. Expected: ${azurerm_user_assigned_identity.organization_identity.id}, Got: ${azurerm_federated_identity_credential.organization_drift_credentials.parent_id}"
  }
  assert {
    condition     = azurerm_federated_identity_credential.organization_drift_credentials.subject == "repo:${var.github_foundations_organization_name}/${var.organizations_repo_name}:ref:refs/heads/${var.drift_detection_branch_name}"
    error_message = "The subject of the organization drift credentials is incorrect. Expected: repo:${var.github_foundations_organization_name}/${var.organizations_repo_name}:ref:refs/heads/${var.drift_detection_branch_name}, Got: ${azurerm_federated_identity_credential.organization_drift_credentials.subject}"
  }
}
