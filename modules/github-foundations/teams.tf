resource "github_team" "foundation_devs" {
  name        = var.foundation_devs_team_name
  description = "Team members with write access to the foundation repositories"
  privacy     = "closed"
}
