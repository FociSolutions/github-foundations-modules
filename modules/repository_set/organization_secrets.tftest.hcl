mock_provider "github" {}

variables {
  public_repositories = {

    "github-foundations-modules" = {
      # required
      description                 = "A collection of terraform modules used in the Github Foundations framework."
      default_branch              = "main"
      protected_branches          = ["main"]
      advance_security            = false
      has_vulnerability_alerts    = true
      topics                      = ["terraform", "github", "foundations"]
      homepage                    = "myhomepage"
      delete_head_on_merge        = false
      dependabot_security_updates = true
      requires_web_commit_signing = false

      # secrets
      organization_action_secrets     = ["org_secret1", "org_secret2"]
      organization_codespace_secrets  = ["org_codespace_secret1", "org_codespace_secret2"]
      organization_dependabot_secrets = ["org_dependabot_secret1", "org_dependabot_secret2"]

    }
  }

  private_repositories = {}

}

run "organization_actions_secrets_test" {
  command = apply

  assert {
    condition     = github_actions_organization_secret_repositories.org__action_secret_repo_access["org_secret1"].secret_name == var.public_repositories["github-foundations-modules"].organization_action_secrets[0]
    error_message = "The repository id value is incorrect. Expected ${var.public_repositories["github-foundations-modules"].organization_action_secrets[0]}, got ${github_actions_organization_secret_repositories.org__action_secret_repo_access["org_secret1"].secret_name}"
  }
  assert {
    condition     = github_actions_organization_secret_repositories.org__action_secret_repo_access["org_secret2"].secret_name == var.public_repositories["github-foundations-modules"].organization_action_secrets[1]
    error_message = "The repository id value is incorrect. Expected ${var.public_repositories["github-foundations-modules"].organization_action_secrets[1]}, got ${github_actions_organization_secret_repositories.org__action_secret_repo_access["org_secret2"].secret_name}"
  }
  assert {
    condition     = tolist(github_actions_organization_secret_repositories.org__action_secret_repo_access["org_secret1"].selected_repository_ids)[0] == 0
    error_message = "The repository id value is incorrect. Expected [0], got ${tolist(github_actions_organization_secret_repositories.org__action_secret_repo_access["org_secret1"].selected_repository_ids)[0]}"
  }
}

run "organization_codespaces_secrets_test" {
  assert {
    condition     = github_codespaces_organization_secret_repositories.org__codespace_secret_repo_access["org_codespace_secret1"].secret_name == var.public_repositories["github-foundations-modules"].organization_codespace_secrets[0]
    error_message = "The repository id value is incorrect. Expected ${var.public_repositories["github-foundations-modules"].organization_codespace_secrets[0]}, got ${github_codespaces_organization_secret_repositories.org__codespace_secret_repo_access["org_codespace_secret1"].secret_name}"
  }
  assert {
    condition     = github_codespaces_organization_secret_repositories.org__codespace_secret_repo_access["org_codespace_secret2"].secret_name == var.public_repositories["github-foundations-modules"].organization_codespace_secrets[1]
    error_message = "The repository id value is incorrect. Expected ${var.public_repositories["github-foundations-modules"].organization_codespace_secrets[1]}, got ${github_codespaces_organization_secret_repositories.org__codespace_secret_repo_access["org_codespace_secret2"].secret_name}"
  }
  assert {
    condition     = tolist(github_codespaces_organization_secret_repositories.org__codespace_secret_repo_access["org_codespace_secret1"].selected_repository_ids)[0] == 0
    error_message = "The repository id value is incorrect. Expected [0], got ${tolist(github_codespaces_organization_secret_repositories.org__codespace_secret_repo_access["org_codespace_secret1"].selected_repository_ids)[0]}"
  }
}

run "organization_dependabot_secrets_test" {
  assert {
    condition     = github_dependabot_organization_secret_repositories.org__dependabot_secret_repo_access["org_dependabot_secret1"].secret_name == var.public_repositories["github-foundations-modules"].organization_dependabot_secrets[0]
    error_message = "The repository id value is incorrect. Expected ${var.public_repositories["github-foundations-modules"].organization_dependabot_secrets[0]}, got ${github_dependabot_organization_secret_repositories.org__dependabot_secret_repo_access["org_dependabot_secret1"].secret_name}"
  }
  assert {
    condition     = github_dependabot_organization_secret_repositories.org__dependabot_secret_repo_access["org_dependabot_secret2"].secret_name == var.public_repositories["github-foundations-modules"].organization_dependabot_secrets[1]
    error_message = "The repository id value is incorrect. Expected ${var.public_repositories["github-foundations-modules"].organization_dependabot_secrets[1]}, got ${github_dependabot_organization_secret_repositories.org__dependabot_secret_repo_access["org_dependabot_secret2"].secret_name}"
  }
  assert {
    condition     = tolist(github_dependabot_organization_secret_repositories.org__dependabot_secret_repo_access["org_dependabot_secret1"].selected_repository_ids)[0] == 0
    error_message = "The repository id value is incorrect. Expected [0], got ${tolist(github_dependabot_organization_secret_repositories.org__dependabot_secret_repo_access["org_dependabot_secret1"].selected_repository_ids)[0]}"
  }
}
