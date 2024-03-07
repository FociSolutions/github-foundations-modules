locals {
  # If no selected repositories are set then sets the field to an empty list
  sanitized_organization_action_secrets = merge(
    var.organization_action_secrets,
    {
      for k, v in var.organization_action_secrets : k => {
        encrypted_value       = v.encrypted_value
        visibility            = v.visibility
        selected_repositories = coalesce(v.selected_repositories, [])
      } if v.visibility == "selected"
    }
  )
  sanitized_organization_codespace_secrets = merge(
    var.organization_codespace_secrets,
    {
      for k, v in var.organization_codespace_secrets : k => {
        encrypted_value       = v.encrypted_value
        visibility            = v.visibility
        selected_repositories = coalesce(v.selected_repositories, [])
      } if v.visibility == "selected"
    }
  )
  sanitized_organization_dependabot_secrets = merge(
    var.organization_dependabot_secrets,
    {
      for k, v in var.organization_dependabot_secrets : k => {
        encrypted_value       = v.encrypted_value
        visibility            = v.visibility
        selected_repositories = coalesce(v.selected_repositories, [])
      } if v.visibility == "selected"
    }
  )
}

resource "github_actions_organization_secret" "action_secret" {
  for_each = local.sanitized_organization_action_secrets

  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = each.value.selected_repositories
}

resource "github_codespaces_organization_secret" "codespace_secret" {
  for_each = local.sanitized_organization_codespace_secrets

  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = each.value.selected_repositories
}

resource "github_dependabot_organization_secret" "dependabot_secret" {
  for_each                = local.sanitized_organization_dependabot_secrets
  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = each.value.selected_repositories
}
