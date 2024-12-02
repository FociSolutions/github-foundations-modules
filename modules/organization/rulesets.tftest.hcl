mock_provider "github" {}

# We need to mock some data sources in this teset
override_data {
  target = data.github_team.branch_ruleset_bypasser["team1"]
  values = {
    id = 2
  }
}

override_data {
  target = data.github_user.branch_ruleset_bypasser["user5"]
  values = {
    id = 5
  }
}

variables {
  github_organization_billing_email = "org_billing_email@focisolutions.com"

  custom_repository_roles = {
    custom_role1 = {
      description = "Custom role 1"
      base_role   = "read"
      permissions = ["pull", "push"]
    }
  }

  default_branch_protection_rulesets = {
    base_protection = {
      enforcement = "evaluate"
    }
    minimum_approvals = {
      enforcement        = "active"
      approvals_required = 1
    }
    dismiss_stale_reviews = {
      enforcement = "disabled"
    }
    require_signatures = {
      enforcement = "evaluate"
    }
    bypass_actors = {
      repository_roles = [
        {
          role          = "maintain"
          always_bypass = false
        }
      ]
      teams = [
        {
          team          = "team1"
          always_bypass = true
        }
      ]
      integrations = [
        {
          installation_id = 333333
          always_bypass   = false
        }
      ]
      organization_admins = [
        {
          user          = "user5"
          always_bypass = true
        }
      ]
    }
  }

  rulesets = {
    ruleset1 = {
      target      = "branch"
      enforcement = "evaluate"

      bypass_actors = {
        repository_roles = [
          {
            role          = "maintain"
            always_bypass = false
          }
        ]
        teams = [
          {
            team          = "team1"
            always_bypass = true
          }
        ]
        integrations = [
          {
            installation_id = 333333
            always_bypass   = false
          }
        ]
        organization_admins = [
          {
            user          = "user5"
            always_bypass = true
          }
        ]
      }
      conditions = {
        ref_name = {
          include = ["main"]
          exclude = ["feature/*"]
        }
        repository_name = {
          include = ["repo1"]
          exclude = ["repo2"]
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

run "ruleset_test" {
  command = apply

  assert {
    condition     = module.ruleset != null
    error_message = "The ruleset is null"
  }
}

# This is crashing Terraform (v.1.9.8)
# run "base_default_branch_protection_ruleset_test" {

#     assert {
#         condition = module.base_default_branch_protection != null
#         error_message   = "The base_default_branch_protection is null"
#     }
# }

# run "minimum_approvals_test" {
#     assert {
#         condition = module.minimum_approvals != null
#         error_message   = "The minimum_approvals is null"
#     }
# }

# run "dismiss_stale_reviews_test" {
#     assert {
#         condition = module.dismiss_stale_reviews != null
#         error_message   = "The dismiss_stale_reviews is null"
#     }
# }

# run "require_signatures_test" {
#     assert {
#         condition = module.require_signatures != null
#         error_message   = "The require_signatures is null"
#     }
# }
