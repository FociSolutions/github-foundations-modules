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
}

run "collaborators_test" {
  command = apply

  assert {
    condition     = github_repository_collaborators.collaborators.repository == var.name
    error_message = "The repository id value is incorrect. Expected ${var.name}, got ${github_repository_collaborators.collaborators.repository}"
  }
  assert {
    condition     = length(github_repository_collaborators.collaborators.team) == length(var.repository_team_permissions)
    error_message = "The number of teams is incorrect. Expected ${length(var.repository_team_permissions)}, got ${length(github_repository_collaborators.collaborators.team)}"
  }
  assert {
    condition     = length(github_repository_collaborators.collaborators.user) == length(var.repository_user_permissions)
    error_message = "The number of users is incorrect. Expected ${length(var.repository_user_permissions)}, got ${length(github_repository_collaborators.collaborators.user)}"
  }
}
