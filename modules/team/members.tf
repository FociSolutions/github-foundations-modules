locals {
  team_id = local.create_team ? github_team.team[0].id : var.team_id
  
  # Combine team_maintainers and team_members into a single map with respective roles
  memberships = merge(
    { for username in var.team_maintainers : username => "maintainer" },
    { for username in var.team_members : username => "member" }
  )
}

resource "github_team_membership" "memberships" {
  for_each = local.memberships
  team_id  = local.team_id
  username = each.key
  role     = each.value
}
