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

  rulesets = {
    ruleset1 = {
      target      = "branch"
      enforcement = "evaluate"
      conditions = {
        ref_name = {
          include = ["main"]
          exclude = ["feature/*"]
        }
      }
      rules = {
        branch_name_pattern = {
          operator = "regex"
          pattern  = "main"
          name     = "branch_name_pattern"
          negate   = false
        }
        commit_author_email_pattern = {
          operator = "regex"
          pattern  = "pattern"
          name     = "commit_author_email_pattern"
          negate   = false
        }
        commit_message_pattern = {
          operator = "regex"
          pattern  = "pattern"
          name     = "commit_message_pattern"
          negate   = false
        }
        committer_email_pattern = {
          operator = "regex"
          pattern  = "pattern"
          name     = "committer_email_pattern"
          negate   = false
        }
        creation                      = true
        deletion                      = false
        update                        = true
        non_fast_forward              = false
        required_linear_history       = true
        required_signatures           = false
        update_allows_fetch_and_merge = true
      }
    }
  }
}

run "rulesets_test" {
  command = apply

  assert {
    condition     = module.ruleset.ruleset1 != null
    error_message = "The ruleset name is null"
  }
}
