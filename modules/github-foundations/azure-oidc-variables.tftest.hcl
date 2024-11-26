mock_provider "github" {}

variables {
  # required variables
  account_type = "Organization"
  oidc_configuration = {
    azure = {
      bootstrap_client_id_variable_name = "bootstrap_client_id_variable_name"
      bootstrap_client_id               = "bootstrap_client_id"

      organization_client_id_variable_name = "organization_client_id_variable_name"
      organization_client_id               = "organization_client_id"

      tenant_id_variable_name = "tenant_id_variable_name"
      tenant_id               = "tenant_id"

      subscription_id_variable_name = "subscription_id_variable_name"
      subscription_id               = "subscription_id"

      resource_group_name_variable_name = "resource_group_name_variable_name"
      resource_group_name               = "resource_group_name"

      storage_account_name_variable_name = "storage_account_name_variable_name"
      storage_account_name               = "storage_account_name"

      container_name_variable_name = "container_name_variable_name"
      container_name               = "container_name"

      key_vault_id_variable_name = "key_vault_id_variable_name"
      key_vault_id               = "key_vault_id"
    }
  }
}

run "organization_managed_identity_client_id_test" {
  command = apply

  assert {
    condition     = github_actions_secret.organization_managed_identity_client_id[0].repository == "organizations"
    error_message = "The org-managed client ID secret repository is incorrect. Expected: 'organizations', got: ${github_actions_secret.organization_managed_identity_client_id[0].repository}"
  }
  assert {
    condition     = github_actions_secret.organization_managed_identity_client_id[0].secret_name == var.oidc_configuration.azure.organization_client_id_variable_name
    error_message = "The org-managed client ID secret name is incorrect. Expected: '${var.oidc_configuration.azure.organization_client_id_variable_name}', got: ${github_actions_secret.organization_managed_identity_client_id[0].secret_name}"
  }
  assert {
    condition     = github_actions_secret.organization_managed_identity_client_id[0].plaintext_value == var.oidc_configuration.azure.organization_client_id
    error_message = "The org-managed client ID secret value is incorrect. Expected: '${var.oidc_configuration.azure.organization_client_id}', got: ${nonsensitive(github_actions_secret.organization_managed_identity_client_id[0].plaintext_value)}"
  }
}

run "bootstrap_managed_identity_client_id_test" {

  assert {
    condition     = github_actions_secret.bootstrap_managed_identity_client_id[0].repository == "bootstrap"
    error_message = "The bootstrap-managed client ID secret repository is incorrect. Expected: 'bootstrap' got: ${github_actions_secret.bootstrap_managed_identity_client_id[0].repository}"
  }
  assert {
    condition     = github_actions_secret.bootstrap_managed_identity_client_id[0].secret_name == var.oidc_configuration.azure.bootstrap_client_id_variable_name
    error_message = "The bootstrap-managed client ID secret name is incorrect. Expected: '${var.oidc_configuration.azure.bootstrap_client_id_variable_name}', got: ${github_actions_secret.bootstrap_managed_identity_client_id[0].secret_name}"
  }
  assert {
    condition     = github_actions_secret.bootstrap_managed_identity_client_id[0].plaintext_value == var.oidc_configuration.azure.bootstrap_client_id
    error_message = "The bootstrap-managed client ID secret value is incorrect. Expected: '${var.oidc_configuration.azure.bootstrap_client_id}', got: ${nonsensitive(github_actions_secret.bootstrap_managed_identity_client_id[0].plaintext_value)}"
  }
}

run "tenant_id_test" {

  assert {
    condition     = github_actions_organization_secret.tenant_id[0].secret_name == var.oidc_configuration.azure.tenant_id_variable_name
    error_message = "The tenant ID secret name is incorrect. Expected: '${var.oidc_configuration.azure.tenant_id_variable_name}', got: ${github_actions_organization_secret.tenant_id[0].secret_name}"
  }
  assert {
    condition     = github_actions_organization_secret.tenant_id[0].plaintext_value == var.oidc_configuration.azure.tenant_id
    error_message = "The tenant ID secret value is incorrect. Expected: '${var.oidc_configuration.azure.tenant_id}', got: ${nonsensitive(github_actions_organization_secret.tenant_id[0].plaintext_value)}"
  }
}

run "subscription_id_test" {

  assert {
    condition     = github_actions_organization_variable.subscription_id[0].variable_name == var.oidc_configuration.azure.subscription_id_variable_name
    error_message = "The subscription ID variable name is incorrect. Expected: '${var.oidc_configuration.azure.subscription_id_variable_name}', got: ${github_actions_organization_variable.subscription_id[0].variable_name}"
  }
  assert {
    condition     = github_actions_organization_variable.subscription_id[0].value == var.oidc_configuration.azure.subscription_id
    error_message = "The subscription ID variable value is incorrect. Expected: '${var.oidc_configuration.azure.subscription_id}', got: ${nonsensitive(github_actions_organization_variable.subscription_id[0].value)}"
  }
}

run "resource_group_name_test" {

  assert {
    condition     = github_actions_organization_variable.resource_group_name[0].variable_name == var.oidc_configuration.azure.resource_group_name_variable_name
    error_message = "The resource group name variable name is incorrect. Expected: '${var.oidc_configuration.azure.resource_group_name_variable_name}', got: ${github_actions_organization_variable.resource_group_name[0].variable_name}"
  }
  assert {
    condition     = github_actions_organization_variable.resource_group_name[0].value == var.oidc_configuration.azure.resource_group_name
    error_message = "The resource group name variable value is incorrect. Expected: '${var.oidc_configuration.azure.resource_group_name}', got: ${nonsensitive(github_actions_organization_variable.resource_group_name[0].value)}"
  }
}

run "storage_account_name_test" {

  assert {
    condition     = github_actions_organization_variable.storage_account_name[0].variable_name == var.oidc_configuration.azure.storage_account_name_variable_name
    error_message = "The storage account name variable name is incorrect. Expected: '${var.oidc_configuration.azure.storage_account_name_variable_name}', got: ${github_actions_organization_variable.storage_account_name[0].variable_name}"
  }
  assert {
    condition     = github_actions_organization_variable.storage_account_name[0].value == var.oidc_configuration.azure.storage_account_name
    error_message = "The storage account name variable value is incorrect. Expected: '${var.oidc_configuration.azure.storage_account_name}', got: ${nonsensitive(github_actions_organization_variable.storage_account_name[0].value)}"
  }
}
