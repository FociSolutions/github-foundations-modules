mock_provider "github" {}

variables {
  name                        = "github-foundations-modules"
  description                 = "A collection of terraform modules used in the Github Foundations framework."
  visibility                  = "public"
  has_downloads               = true
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  has_discussions             = true
  has_vulnerability_alerts    = true
  topics                      = ["terraform", "github", "foundations"]
  homepage                    = "myhomepage"
  delete_head_on_merge        = false
  allow_auto_merge            = true
  allow_squash_merge          = false
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  allow_merge_commit          = false
  merge_commit_message        = "PR_BODY"
  merge_commit_title          = "PR_TITLE"
  allow_rebase_merge          = true
  requires_web_commit_signing = false
  license_template            = "mit"
  dependabot_security_updates = true
  advance_security            = true
  secret_scanning             = true
  secret_scanning_on_push     = true

  default_branch     = "main"
  protected_branches = ["main", "develop"]

  template_repository = {
    owner                = "owner"
    repository           = "template_repository"
    include_all_branches = true
  }

  pages = {
    source = {
      branch = "main"
      path   = "path"
    }
    cname = "cname"
  }

  repository_team_permissions = {
    repo_team1 = "push"
    repo_team2 = "admin"
  }
  repository_user_permissions = {
    user1 = "push"
    user2 = "admin"
  }
}

run "create_test" {
  command = apply

  assert {
    condition     = module.repository_base.id != null
    error_message = "The repository was not created"
  }
}
