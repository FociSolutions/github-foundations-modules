locals {
  # If no selected repositories are set then sets the field to an empty list
  sanitized_action_secrets = merge(
    var.actions_secrets,
    {
      for k, v in var.actions_secrets : k => {
        encrypted_value       = v.encrypted_value
        visibility            = v.visibility
        selected_repositories = coalesce(v.selected_repositories, [])
      } if v.visibility == "selected"
    }
  )
  sanitized_codespace_secrets = merge(
    var.codespaces_secrets,
    {
      for k, v in var.codespaces_secrets : k => {
        encrypted_value       = v.encrypted_value
        visibility            = v.visibility
        selected_repositories = coalesce(v.selected_repositories, [])
      } if v.visibility == "selected"
    }
  )
  sanitized_dependabot_secrets = merge(
    var.dependabot_secrets,
    {
      for k, v in var.dependabot_secrets : k => {
        encrypted_value       = v.encrypted_value
        visibility            = v.visibility
        selected_repositories = coalesce(v.selected_repositories, [])
      } if v.visibility == "selected"
    }
  )


  all_selected_repositories = concat(
    flatten([for secret in values(var.var.actions_secrets) : secret.selected_repositories if secret.visibility == "selected" && secret.selected_repositories != null]),
    flatten([for secret in values(var.codespaces_secrets) : secret.selected_repositories if secret.visibility == "selected" && secret.selected_repositories != null]),
    flatten([for secret in values(var.dependabot_secrets) : secret.selected_repositories if secret.visibility == "selected" && secret.selected_repositories != null])
  )
}

data "github_repository" "selected_repositories" {
  for_each  = toset(local.all_selected_repositories)
  full_name = "${github_organization_settings.organization_settings.name}/${each.value}"
}

resource "github_actions_organization_secret" "action_secret" {
  for_each = local.sanitized_action_secrets

  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = [for repo in each.value.selected_repositories : data.github_repository.selected_repositories["${index(data.github_repository.selected_repositories.*.name, repo)}"]]
}

resource "github_codespaces_organization_secret" "codespace_secret" {
  for_each = local.sanitized_codespace_secrets

  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = [for repo in each.value.selected_repositories : data.github_repository.selected_repositories["${index(data.github_repository.selected_repositories.*.name, repo)}"]]
}

resource "github_dependabot_organization_secret" "dependabot_secret" {
  for_each                = local.sanitized_dependabot_secrets
  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = [for repo in each.value.selected_repositories : data.github_repository.selected_repositories["${index(data.github_repository.selected_repositories.*.name, repo)}"]]
}

