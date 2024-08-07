output "resource_group" {
  description = "Resource group name."
  value       = local.github_foundations_rg.name
}

output "bootstrap_client_id" {
  description = "Bootstrap repository client id for authenticating with oidc."
  value       = azurerm_user_assigned_identity.bootstrap_identity.client_id
}

output "organization_client_id" {
  description = "Organizations repository client id for authenticating with oidc."
  value       = azurerm_user_assigned_identity.organization_identity.client_id
}

output "tenant_id" {
  description = "Azure tenant id for authenticating with oidc."
  value       = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  description = "Azure subscription id for authenticating with oidc."
  value       = data.azurerm_client_config.current.subscription_id
}

output "sa_name" {
  description = "Terraform state container storage account name."
  value       = azurerm_storage_account.github_foundations_sa.name
}

output "container_name" {
  description = "Terraform state container name."
  value       = local.tf_state_container.name
}

output "key_vault_id" {
  description = "Azure key vault id for github foundation secrets."
  value       = var.kv_name != "" ? data.azurerm_key_vault.key_vault[0].id : ""
}
