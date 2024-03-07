locals {
  action_secrets_per_environment = {
    for env_name, env in coalesce(var.environments, {}): env_name => [ for secret_name, secret_value in env.action_secrets : { name = secret_name, encrypted_value = secret_value}] if env.action_secrets != null
  }
  
  environment_action_secrets = {
    for env_name, secrets in local.action_secrets_per_environment: "${env_name}:${secrets[*].name}" => {
      environment     = env_name
      name            = secrets[*].name
      value          = secrets[*].encrypted_value
    }
  }
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
  for_each        = local.environment_action_secrets
  repository      = var.name
  environment     = each.value.environment
  encrypted_value = each.value.encrypted_value
  secret_name     = each.value.name
}
