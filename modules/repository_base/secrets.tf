locals {
  environment_actions_secrets = flatten([
    for env_name, env in coalesce(var.environments, {}) : [for secret_name, secret in env.action_secrets : {
      name            = secret_name
      encrypted_value = secret
      environment     = env_name
    }] if env.action_secrets != null 
  ])
}

resource "github_actions_secret" "actions_secret" {
  for_each = coalesce(var.action_secrets, {})

  repository      = github_repository.repository.name
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_codespaces_secret" "codespaces_secret" {
  for_each = coalesce(var.codespace_secrets, {})

  repository      = github_repository.repository.name
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_dependabot_secret" "dependabot_secret" {
  for_each = coalesce(var.dependabot_secrets, {})

  repository      = github_repository.repository.name
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_actions_environment_secret" "environment_secret" {
  for_each        = toset(local.environment_actions_secrets)
  repository      = var.name
  environment     = each.value.environment
  encrypted_value = each.value.encrypted_value
  secret_name     = each.value.name
}
