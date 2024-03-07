locals {
  environment_actions_secrets = concat(values({
    for env_name, env in var.environments : env_name => [for secret_name, secret in env.action_secrets : {
      name            = secret_name
      encrypted_value = secret
      environment     = env_name
    }] if env.action_secrets != null
  }))
}

resource "github_actions_secret" "actions_secret" {
  for_each = var.action_secrets

  repository      = github_repository.repository.name
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_codespaces_secret" "codespaces_secret" {
  for_each = var.codespace_secrets

  repository      = github_repository.repository.name
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_dependabot_secret" "dependabot_secret" {
  for_each = var.dependabot_secrets

  repository      = github_repository.repository.name
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_actions_environment_secret" "environment_secret" {
  for_each        = local.environment_actions_secrets
  repository      = var.name
  environment     = each.value.environment
  encrypted_value = each.value.encrypted_value
  secret_name     = each.value.name
}
