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
  environments = {
    "env1" = {
      wait_timer          = 10
      can_admins_bypass   = true
      prevent_self_review = false
      action_secrets = {
        "action_secret1" = "dmFsdWUxCg==" # base64 encoded
      }
      reviewers = {
        teams = [111, 222]
        users = [55, 66]
      }
      deployment_branch_policy = {
        protected_branches     = true
        custom_branch_policies = false
        branch_patterns        = ["main"]
      }
    }
  }

}

run "create_environment_test" {
  command = apply

  assert {
    condition     = github_repository_environment.environment["env1"].repository == var.name
    error_message = "The repository id value is incorrect. Expected ${var.name}, got ${github_repository_environment.environment["env1"].repository}"
  }
  assert {
    condition     = github_repository_environment.environment["env1"].environment == "env1"
    error_message = "The environment name value is incorrect. Expected env1, got ${github_repository_environment.environment["env1"].environment}"
  }
  assert {
    condition     = github_repository_environment.environment["env1"].wait_timer == var.environments["env1"].wait_timer
    error_message = "The wait timer value is incorrect. Expected ${var.environments["env1"].wait_timer}, got ${github_repository_environment.environment["env1"].wait_timer}"
  }
  assert {
    condition     = github_repository_environment.environment["env1"].can_admins_bypass == var.environments["env1"].can_admins_bypass
    error_message = "The can admins bypass value is incorrect. Expected ${var.environments["env1"].can_admins_bypass}, got ${github_repository_environment.environment["env1"].can_admins_bypass}"
  }
  assert {
    condition     = github_repository_environment.environment["env1"].prevent_self_review == var.environments["env1"].prevent_self_review
    error_message = "The prevent self review value is incorrect. Expected ${var.environments["env1"].prevent_self_review}, got ${github_repository_environment.environment["env1"].prevent_self_review}"
  }
  assert {
    condition     = length(github_repository_environment.environment["env1"].reviewers["0"].teams) == length(var.environments["env1"].reviewers.teams)
    error_message = "The reviewers teams value is incorrect. Expected ${length(var.environments["env1"].reviewers.teams)}, got ${length(github_repository_environment.environment["env1"].reviewers["0"].teams)}"
  }
  assert {
    condition     = length(github_repository_environment.environment["env1"].reviewers["0"].users) == length(var.environments["env1"].reviewers.users)
    error_message = "The reviewers users value is incorrect. Expected ${length(var.environments["env1"].reviewers.users)}, got ${length(github_repository_environment.environment["env1"].reviewers["0"].users)}"
  }
  assert {
    condition     = github_repository_environment.environment["env1"].deployment_branch_policy["0"].protected_branches == var.environments["env1"].deployment_branch_policy.protected_branches
    error_message = "The deployment branch policy protected branches value is incorrect. Expected ${var.environments["env1"].deployment_branch_policy.protected_branches}, got ${github_repository_environment.environment["env1"].deployment_branch_policy["0"].protected_branches}"
  }
  assert {
    condition     = github_repository_environment.environment["env1"].deployment_branch_policy["0"].custom_branch_policies == var.environments["env1"].deployment_branch_policy.custom_branch_policies
    error_message = "The deployment branch policy custom branch policies value is incorrect. Expected ${var.environments["env1"].deployment_branch_policy.custom_branch_policies}, got ${github_repository_environment.environment["env1"].deployment_branch_policy["0"].custom_branch_policies}"
  }
  assert {
    condition     = length(github_repository_environment_deployment_policy.deployment_policy) == length(var.environments["env1"].deployment_branch_policy.branch_patterns)
    error_message = "The deployment policy length is incorrect. Expected ${length(var.environments["env1"].deployment_branch_policy.branch_patterns)}, got ${length(github_repository_environment_deployment_policy.deployment_policy)}"
  }
}

run "deployment_policy_test" {
  assert {
    condition     = github_repository_environment_deployment_policy.deployment_policy["env1:main"].repository == var.name
    error_message = "The repository id value is incorrect. Expected ${var.name}, got ${github_repository_environment_deployment_policy.deployment_policy["env1:main"].repository}"
  }
  assert {
    condition     = github_repository_environment_deployment_policy.deployment_policy["env1:main"].environment == "env1"
    error_message = "The environment name value is incorrect. Expected env1, got ${github_repository_environment_deployment_policy.deployment_policy["env1:main"].environment}"
  }
  assert {
    condition     = github_repository_environment_deployment_policy.deployment_policy["env1:main"].branch_pattern == "main"
    error_message = "The branch pattern value is incorrect. Expected main, got ${github_repository_environment_deployment_policy.deployment_policy["env1:main"].branch_pattern}"
  }
}
