import {
  for_each = var.import ? [] : [var.team_name]
  to = github_team.team
  id = each.value
}

resource "github_team" "team" {
  name           = var.team_name
  description    = var.team_description
  privacy        = var.privacy
  parent_team_id = var.parent_id
}
