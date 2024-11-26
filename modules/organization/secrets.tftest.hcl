mock_provider "github" {}

variables {
  github_organization_billing_email = "org_billing_email@focisolutions.com"

  custom_repository_roles = {
    custom_role1 = {
      description = "Custom role 1"
      base_role   = "read"
      permissions = ["pull", "push"]
    }
  }

  actions_secrets = {
    action_secret1 = {
      encrypted_value = "dmFsdWUxCg==" # base64 encoded
      visibility      = "all"
    },
    action_secret2 = {
      encrypted_value = "dmFsdWUyCg==" # base64 encoded
      visibility      = "private"
    }

  }

  codespaces_secrets = {
    codespace_secret1 = {
      encrypted_value = "dmFsdWUxCg==" # base64 encoded
      visibility      = "all"
    }
  }

  dependabot_secrets = {
    dependabot_secret1 = {
      encrypted_value = "dmFsdWUxCg==" # base64 encoded
      visibility      = "all"
    },
    dependabot_secret2 = {
      encrypted_value = "dmFsdWUyCg==" # base64 encoded
      visibility      = "private"
    },
    dependabot_secret3 = {
      encrypted_value = "dmFsdWUzCg==" # base64 encoded
      visibility      = "private"
    }
  }
}

run "action_secret_test" {
  command = apply

  assert {
    condition     = github_actions_organization_secret.action_secret["action_secret1"].secret_name == "action_secret1"
    error_message = "The action secret name is incorrect. Expected `action_secret1`, got `${github_actions_organization_secret.action_secret["action_secret1"].secret_name}`"
  }
  assert {
    condition     = github_actions_organization_secret.action_secret["action_secret1"].encrypted_value == "dmFsdWUxCg=="
    error_message = "The action secret encrypted value is incorrect. Expected `dmFsdWUxCg==`, got `${nonsensitive(github_actions_organization_secret.action_secret["action_secret1"].encrypted_value)}`"
  }
  assert {
    condition     = github_actions_organization_secret.action_secret["action_secret1"].visibility == "all"
    error_message = "The action secret visibility is incorrect. Expected `all`, got `${github_actions_organization_secret.action_secret["action_secret1"].visibility}`"
  }
  assert {
    condition     = length(github_actions_organization_secret.action_secret["action_secret1"].selected_repository_ids) == 0
    error_message = "The action secret selected repository ids is incorrect. Expected `0`, got `${length(github_actions_organization_secret.action_secret["action_secret1"].selected_repository_ids)}`"
  }
  assert {
    condition     = github_actions_organization_secret.action_secret["action_secret2"].secret_name == "action_secret2"
    error_message = "The action secret name is incorrect. Expected `action_secret2`, got `${github_actions_organization_secret.action_secret["action_secret2"].secret_name}`"
  }
  assert {
    condition     = github_actions_organization_secret.action_secret["action_secret2"].encrypted_value == "dmFsdWUyCg=="
    error_message = "The action secret encrypted value is incorrect. Expected `dmFsdWUyCg==`, got `${nonsensitive(github_actions_organization_secret.action_secret["action_secret2"].encrypted_value)}`"
  }
  assert {
    condition     = github_actions_organization_secret.action_secret["action_secret2"].visibility == "private"
    error_message = "The action secret visibility is incorrect. Expected `private`, got `${github_actions_organization_secret.action_secret["action_secret2"].visibility}`"
  }
  assert {
    condition     = length(github_actions_organization_secret.action_secret["action_secret2"].selected_repository_ids) == 0
    error_message = "The action secret selected repository ids is incorrect. Expected `0`, got `${length(github_actions_organization_secret.action_secret["action_secret2"].selected_repository_ids)}`"
  }
}

run "codespace_secret_test" {

  assert {
    condition     = github_codespaces_organization_secret.codespace_secret["codespace_secret1"].secret_name == "codespace_secret1"
    error_message = "The codespace secret name is incorrect. Expected `codespace_secret1`, got `${github_codespaces_organization_secret.codespace_secret["codespace_secret1"].secret_name}`"
  }
  assert {
    condition     = github_codespaces_organization_secret.codespace_secret["codespace_secret1"].encrypted_value == "dmFsdWUxCg=="
    error_message = "The codespace secret encrypted value is incorrect. Expected `dmFsdWUxCg==`, got `${nonsensitive(github_codespaces_organization_secret.codespace_secret["codespace_secret1"].encrypted_value)}`"
  }
  assert {
    condition     = github_codespaces_organization_secret.codespace_secret["codespace_secret1"].visibility == "all"
    error_message = "The codespace secret visibility is incorrect. Expected `all`, got `${github_codespaces_organization_secret.codespace_secret["codespace_secret1"].visibility}`"
  }
  assert {
    condition     = length(github_codespaces_organization_secret.codespace_secret["codespace_secret1"].selected_repository_ids) == 0
    error_message = "The codespace secret selected repository ids is incorrect. Expected `0`, got `${length(github_codespaces_organization_secret.codespace_secret["codespace_secret1"].selected_repository_ids)}`"
  }
}

run "dependabot_secret_test" {
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].secret_name == "dependabot_secret1"
    error_message = "The dependabot secret name is incorrect. Expected `dependabot_secret1`, got `${github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].secret_name}`"
  }
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].encrypted_value == "dmFsdWUxCg=="
    error_message = "The dependabot secret encrypted value is incorrect. Expected `dmFsdWUxCg==`, got `${nonsensitive(github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].encrypted_value)}`"
  }
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].visibility == "all"
    error_message = "The dependabot secret visibility is incorrect. Expected `all`, got `${github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].visibility}`"
  }
  assert {
    condition     = length(github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].selected_repository_ids) == 0
    error_message = "The dependabot secret selected repository ids is incorrect. Expected `0`, got `${length(github_dependabot_organization_secret.dependabot_secret["dependabot_secret1"].selected_repository_ids)}`"
  }
  # test the second secret
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].secret_name == "dependabot_secret2"
    error_message = "The dependabot secret name is incorrect. Expected `dependabot_secret2`, got `${github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].secret_name}`"
  }
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].encrypted_value == "dmFsdWUyCg=="
    error_message = "The dependabot secret encrypted value is incorrect. Expected `dmFsdWUyCg==`, got `${nonsensitive(github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].encrypted_value)}`"
  }
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].visibility == "private"
    error_message = "The dependabot secret visibility is incorrect. Expected `private`, got `${github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].visibility}`"
  }
  assert {
    condition     = length(github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].selected_repository_ids) == 0
    error_message = "The dependabot secret selected repository ids is incorrect. Expected `0`, got `${length(github_dependabot_organization_secret.dependabot_secret["dependabot_secret2"].selected_repository_ids)}`"
  }
  # test the third secret
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].secret_name == "dependabot_secret3"
    error_message = "The dependabot secret name is incorrect. Expected `dependabot_secret3`, got `${github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].secret_name}`"
  }
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].encrypted_value == "dmFsdWUzCg=="
    error_message = "The dependabot secret encrypted value is incorrect. Expected `dmFsdWUzCg==`, got `${nonsensitive(github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].encrypted_value)}`"
  }
  assert {
    condition     = github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].visibility == "private"
    error_message = "The dependabot secret visibility is incorrect. Expected `private`, got `${github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].visibility}`"
  }
  assert {
    condition     = length(github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].selected_repository_ids) == 0
    error_message = "The dependabot secret selected repository ids is incorrect. Expected `0`, got `${length(github_dependabot_organization_secret.dependabot_secret["dependabot_secret3"].selected_repository_ids)}`"
  }
}
