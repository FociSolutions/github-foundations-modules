mock_provider "github" {}

variables {
  name        = "github-foundations-modules"
  description = "A collection of terraform modules used in the Github Foundations framework."

  repository_team_permissions = {
    "repo_team1" = "push"
    "repo_team2" = "admin"
  }
  repository_user_permissions = {
    "user1" = "push"
    "user2" = "admin"
  }

  action_secrets = {
    "action_secret1" = "dmFsdWUxCg=="
  }

  codespace_secrets = {
    "codespace_secret1" = "dmFsdWUxCg=="
  }

  dependabot_secrets = {
    "dependabot_secret1" = "dmFsdWUxCg=="
  }
}

run "actions_secret_test" {
  command = apply

  assert {
    condition     = github_actions_secret.actions_secret["action_secret1"].secret_name == "action_secret1"
    error_message = "The secret name value is incorrect. Expected \"action_secret1\", got ${github_actions_secret.actions_secret["action_secret1"].secret_name}"
  }
  assert {
    condition     = github_actions_secret.actions_secret["action_secret1"].encrypted_value == "dmFsdWUxCg==" # "value1" base64 encoded
    error_message = "The encrypted value is incorrect. Expected \"dmFsdWUxCg==\", got ${nonsensitive(github_actions_secret.actions_secret["action_secret1"].encrypted_value)}"
  }

}

run "namespaced_secrets_test" {

  assert {
    condition     = github_codespaces_secret.codespaces_secret["codespace_secret1"].secret_name == "codespace_secret1"
    error_message = "The secret name value is incorrect. Expected \"codespace_secret1\", got ${github_codespaces_secret.codespaces_secret["codespace_secret1"].secret_name}"
  }
  assert {
    condition     = github_codespaces_secret.codespaces_secret["codespace_secret1"].encrypted_value == "dmFsdWUxCg=="
    error_message = "The encrypted value is incorrect. Expected \"dmFsdWUxCg==\", got ${nonsensitive(github_codespaces_secret.codespaces_secret["codespace_secret1"].encrypted_value)}"
  }
}

run "dependabot_secrets_test" {

  assert {
    condition     = github_dependabot_secret.dependabot_secret["dependabot_secret1"].secret_name == "dependabot_secret1"
    error_message = "The secret name value is incorrect. Expected \"dependabot_secret1\", got ${github_dependabot_secret.dependabot_secret["dependabot_secret1"].secret_name}"
  }
  assert {
    condition     = github_dependabot_secret.dependabot_secret["dependabot_secret1"].encrypted_value == "dmFsdWUxCg=="
    error_message = "The encrypted value is incorrect. Expected \"dmFsdWUxCg==\", got ${nonsensitive(github_dependabot_secret.dependabot_secret["dependabot_secret1"].encrypted_value)}"
  }
}
