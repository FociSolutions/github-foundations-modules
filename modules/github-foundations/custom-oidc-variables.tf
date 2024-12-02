locals {
  expanded_list_of_repo_secrets = try(merge(
    [
      for repo, secrets in var.oidc_configuration.custom.repository_secrets : {
        for name, encrypted_value in secrets : "${repo}_${name}" => {
          name            = name
          encrypted_value = encrypted_value
          repository      = repo
        }
      }
    ]...
  ), {})

  expanded_list_of_repo_variables = try(merge(
    [
      for repo, variables in var.oidc_configuration.custom.repository_variables : {
        for name, value in variables : "${repo}_${name}" => {
          name       = name
          value      = value
          repository = repo
        }
      }
    ]...
  ), {})
}

resource "github_actions_organization_secret" "custom_oidc_organization_secret" {
  for_each = try(var.oidc_configuration.custom.organization_secrets, {})

  secret_name     = each.key
  encrypted_value = each.value
  visibility      = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "custom_oidc_organization_variable" {
  for_each = try(var.oidc_configuration.custom.organization_variables, {})

  variable_name = each.key
  value         = each.value
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_secret" "repository_secret" {
  for_each = local.expanded_list_of_repo_secrets

  repository      = each.value.repository
  secret_name     = each.value.name
  encrypted_value = each.value.encrypted_value
}

resource "github_actions_variable" "repository_variable" {
  for_each = local.expanded_list_of_repo_variables

  repository    = each.value.repository
  variable_name = each.value.name
  value         = each.value.value
}
