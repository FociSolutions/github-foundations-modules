mock_provider "github" {}

variables {
  public_repositories = {

    "github-foundations-modules" = {
      description                 = "A collection of terraform modules used in the Github Foundations framework."
      default_branch              = "main"
      protected_branches          = ["main"]
      advance_security            = false
      has_vulnerability_alerts    = true
      topics                      = ["terraform", "github", "foundations"]
      homepage                    = "myhomepage"
      delete_head_on_merge        = false
      dependabot_security_updates = true
      requires_web_commit_signing = false
      allow_auto_merge            = true
      allow_squash_merge          = false
      allow_rebase_merge          = true
      allow_merge_commit          = false
      squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
      squash_merge_commit_message = "COMMIT_MESSAGES"
      merge_commit_title          = "PR_TITLE"
      merge_commit_message        = "PR_BODY"
      repository_team_permissions_override = {
        "repo_team1" = "push"
        "repo_team2" = "admin"
      }
      user_permissions = {
        "user1" = "push"
        "user2" = "admin"
      }


      action_secrets = {
        "action_secret1" = "value1"
      }

      codespace_secrets = {
        "codespace_secret1" = "value1"
      }

      dependabot_secrets = {
        "dependabot_secret1" = "value1"
      }

      environments = {
        "env1" = {
          wait_timer          = 10
          can_admins_bypass   = true
          prevent_self_review = false
          action_secrets = {
            "action_secret1" = "dmFsdWUxCg==" # base64 encoded
          }
          reviewers = {
            teams = [111, 222]
            users = [55, 66]
          }
          deployment_branch_policy = {
            protected_branches     = true
            custom_branch_policies = false
            branch_patterns        = ["main"]
          }
        }
      }

      template_repository = {
        owner                = "owner"
        repository           = "template_repository"
        include_all_branches = true
      }

      license_template = "mit"

      pages = {
        source = {
          branch = "main"
          path   = "path"
        }
        # build_type = "build_type"
        cname = "cname"
      }
    }
  }

  private_repositories = {
    private-github-foundations-modules = {
      description                 = "A collection of terraform modules used in the Github Foundations framework."
      default_branch              = "main"
      protected_branches          = ["main"]
      advance_security            = false
      has_vulnerability_alerts    = true
      topics                      = ["terraform", "github", "foundations"]
      homepage                    = "myhomepage"
      delete_head_on_merge        = false
      dependabot_security_updates = true
      requires_web_commit_signing = false
      allow_auto_merge            = true
      allow_squash_merge          = false
      allow_rebase_merge          = true
      allow_merge_commit          = false
      squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
      squash_merge_commit_message = "COMMIT_MESSAGES"
      merge_commit_title          = "PR_TITLE"
      merge_commit_message        = "PR_BODY"
      repository_team_permissions_override = {
        "repo_team1" = "push"
        "repo_team2" = "admin"
      }
      user_permissions = {
        "user1" = "push"
        "user2" = "admin"
      }


      action_secrets = {
        "action_secret1" = "value1"
      }

      codespace_secrets = {
        "codespace_secret1" = "value1"
      }

      dependabot_secrets = {
        "dependabot_secret1" = "value1"
      }

      environments = {
        "env1" = {
          wait_timer          = 10
          can_admins_bypass   = true
          prevent_self_review = false
          action_secrets = {
            "action_secret1" = "dmFsdWUxCg==" # base64 encoded
          }
          reviewers = {
            teams = [111, 222]
            users = [55, 66]
          }
          deployment_branch_policy = {
            protected_branches     = true
            custom_branch_policies = false
            branch_patterns        = ["main"]
          }
        }
      }

      template_repository = {
        owner                = "owner"
        repository           = "template_repository"
        include_all_branches = true
      }

      license_template = "mit"

      pages = {
        source = {
          branch = "main"
          path   = "path"
        }
        cname = "cname"
      }
    }
  }

  has_ghas_license = true

  default_repository_team_permissions = {
    GhFoundationsAdmins     = "admin"
    GhFoundationsDevelopers = "push"
  }

  internal_repositories = {

    "internal-github-foundations-modules" = {
      description                 = "A collection of terraform modules used in the Github Foundations framework."
      default_branch              = "main"
      protected_branches          = ["main"]
      advance_security            = false
      has_vulnerability_alerts    = true
      topics                      = ["terraform", "github", "foundations"]
      homepage                    = "myhomepage"
      delete_head_on_merge        = false
      dependabot_security_updates = true
      requires_web_commit_signing = false
      allow_auto_merge            = true
      allow_squash_merge          = false
      allow_rebase_merge          = true
      allow_merge_commit          = false
      squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
      squash_merge_commit_message = "COMMIT_MESSAGES"
      merge_commit_title          = "PR_TITLE"
      merge_commit_message        = "PR_BODY"
      repository_team_permissions_override = {
        "repo_team1" = "push"
        "repo_team2" = "admin"
      }
      user_permissions = {
        "user1" = "push"
        "user2" = "admin"
      }


      action_secrets = {
        "action_secret1" = "value1"
      }

      codespace_secrets = {
        "codespace_secret1" = "value1"
      }

      dependabot_secrets = {
        "dependabot_secret1" = "value1"
      }

      environments = {
        "env1" = {
          wait_timer          = 10
          can_admins_bypass   = true
          prevent_self_review = false
          action_secrets = {
            "action_secret1" = "dmFsdWUxCg==" # base64 encoded
          }
          reviewers = {
            teams = [111, 222]
            users = [55, 66]
          }
          deployment_branch_policy = {
            protected_branches     = true
            custom_branch_policies = false
            branch_patterns        = ["main"]
          }
        }
      }

      template_repository = {
        owner                = "owner"
        repository           = "template_repository"
        include_all_branches = true
      }

      license_template = "mit"

      pages = {
        source = {
          branch = "main"
          path   = "path"
        }
        # build_type = "build_type"
        cname = "cname"
      }
    }
  }
}

run "apply" {
  command = apply
}

run "public_repository_test" {
  assert {
    condition     = module.public_repositories["github-foundations-modules"].id != null
    error_message = "The repository id value is incorrect. Expected not null, got ${module.public_repositories["github-foundations-modules"].id}"
  }
}

run "private_repository_test" {
  assert {
    condition     = module.private_repositories["private-github-foundations-modules"].id != null
    error_message = "The repository id value is incorrect. Expected not null, got ${module.private_repositories["private-github-foundations-modules"].id}"
  }
}

run "internal_repository_test" {
  assert {
    condition     = module.internal_repositories["internal-github-foundations-modules"].id != null
    error_message = "The repository id value is incorrect. Expected not null, got ${module.internal_repositories["internal-github-foundations-modules"].id}"
  }
}
