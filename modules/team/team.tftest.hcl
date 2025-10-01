mock_provider "github" {
}

variables {
  team_name        = "team 1"
  team_description = "This is a test team"
  privacy          = "closed"
  team_maintainers = ["user1", "user2"]
  team_members     = ["user3", "user4", "user5"]
  team_id          = "888"
  parent_id        = "777"
}

run "team_test" {

  command = apply

  assert {
    condition     = github_team_membership.memberships[var.team_maintainers[0]].team_id == var.team_id
    error_message = "The maintainer's team id is incorrect. Expected: ${var.team_id}, Actual: ${github_team_membership.memberships[var.team_maintainers[0]].team_id}"
  }
  assert {
    condition     = github_team_membership.memberships[var.team_maintainers[0]].username == var.team_maintainers[0]
    error_message = "The maintainer's username is incorrect. Expected: ${var.team_maintainers[0]}, Actual: ${github_team_membership.memberships[var.team_maintainers[0]].username}"
  }
  assert {
    condition     = github_team_membership.memberships[var.team_maintainers[0]].role == "maintainer"
    error_message = "The maintainer's role is incorrect. Expected: maintainer, Actual: ${github_team_membership.memberships[var.team_maintainers[0]].role}"
  }
}

run "team_member_test" {
  assert {
    condition     = github_team_membership.memberships[var.team_members[0]].team_id == var.team_id
    error_message = "The member's team id is incorrect. Expected: ${var.team_id}, Actual: ${github_team_membership.memberships[var.team_members[0]].team_id}"
  }
  assert {
    condition     = github_team_membership.memberships[var.team_members[0]].username == var.team_members[0]
    error_message = "The member's username is incorrect. Expected: ${var.team_members[0]}, Actual: ${github_team_membership.memberships[var.team_members[0]].username}"
  }
  assert {
    condition     = github_team_membership.memberships[var.team_members[0]].role == "member"
    error_message = "The member's role is incorrect. Expected: member, Actual: ${github_team_membership.memberships[var.team_members[0]].role}"
  }

}
