locals {
  preexisting_teams = {
    for team_name, team_config in var.teams : team_name => team_config if coalesce(team_config.import, false)
  }
}

import {
  for_each = local.preexisting_teams

  to = module.team[each.key].github_team.team
  id = each.key
}

module "team" {
  source = "../team"

  for_each = var.teams

  team_maintainers = each.value.maintainers
  team_members     = each.value.members
  team_description = each.value.description
  privacy          = each.value.privacy
  parent_id        = each.value.parent_id
  team_name        = each.key
}