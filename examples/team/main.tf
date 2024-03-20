module "example_github_team" {
  source = "../../modules/team"

  team_name        = "devops-team"
  privacy          = "closed"
  team_description = "Responsible for CI/CD pipelines and infrastructure."
  team_maintainers = ["alice", "bob"]
  team_members     = ["carol", "dave"]
  parent_id        = "123456789" # Optional: Include this only if you're creating a nested team.
}
