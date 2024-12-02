mock_provider "github" {
  mock_resource "github_team" {
    defaults = {
      slug = "team-1"
    }

  }
}

variables {
  teams = {
    "team-1" = {
      maintainers = ["user1"]
      members     = ["user2"]
      description = "This is a test team"
      privacy     = "closed"
      parent_id   = 777
    },
    "team-2" = {
      maintainers = ["user1", "user2"]
      members     = ["user3"]
      description = "This is another test team"
      privacy     = "closed"
      parent_id   = 888
    },
    "team-3" = {
      maintainers = ["user1", "user2", "user3"]
      members     = ["user4", "user5"]
      description = "This is a third test team"
      privacy     = "secret"
      parent_id   = 999
    }
  }
}

run "create_teams" {

  command = apply

  assert {
    condition     = module.team.team-1.name == "team-1"
    error_message = "The team name is incorrect. Expected team-1 but got ${module.team.team-1.name}"
  }
  assert {
    condition     = module.team.team-1.slug == "team-1"
    error_message = "The team slug is incorrect. Expected team-1 but got ${module.team.team-1.slug}"
  }
  assert {
    condition     = module.team.team-2.name == "team-2"
    error_message = "The team name is incorrect. Expected team-2 but got ${module.team.team-2.name}"
  }
  assert {
    condition     = module.team["team-3"].name == "team-3"
    error_message = "The team name is incorrect. Expected team-3 but got ${module.team.team-3.name}"
  }
}
