locals {
  environment_action_secrets_list = flatten([
    for env_name, env in coalesce(var.environments, {}) : [for secret_name, secret_value in env.action_secrets : { name = secret_name, encrypted_value = secret_value, environment = env_name }] if env.action_secrets != null
  ])

  # Terraform can't loop over a list of objects so we convert it into a map
  environment_action_secrets_map = {
    for environment_secret in local.environment_action_secrets_list : "${environment_secret.environment}:${environment_secret.name}" => {
      environment     = environment_secret.environment
      name            = environment_secret.name
      encrypted_value = environment_secret.encrypted_value
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
  for_each        = local.environment_action_secrets_map
  depends_on = [ github_repository_environment.environemnt[*] ]
  repository      = var.name
  environment     = each.value.environment
  encrypted_value = each.value.encrypted_value
  secret_name     = each.value.name
}
