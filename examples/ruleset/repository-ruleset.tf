module "github_repo_ruleset" {
  source = "../../modules/ruleset"

  name       = "repo-specific-ruleset"
  repository = "my-target-repo"
  bypass_actors = {
    repository_roles = [
      { role_id = "maintainer_id", always_bypass = true }
    ],
    teams = [
      { team_id = "team_id", always_bypass = false }
    ]
  }
  rules = {
    branch_name_pattern = {
      operator = "equals",
      pattern  = "release/*",
      negate   = false
    },
    commit_message_pattern = {
      operator = "matches",
      pattern  = "^(feat|fix|chore|docs|style|refactor|perf|test):\\s.+",
      negate   = false
    },
    pull_request = {
      dismiss_stale_reviews_on_push     = true,
      require_code_owner_review         = true,
      required_approving_review_count   = 2,
      required_review_thread_resolution = true
    },
    required_status_checks = {
      required_check = [
        { context = "ci/build", integration_id = 12345 }
      ],
      strict_required_status_check_policy = true
    }
  }
  ref_name_inclusions        = ["release/*", "main"]
  ref_name_exclusions        = []
  repository_name_inclusions = ["my-target-repo"] # This field is ignored in repository-specific rulesets but included for clarity.
  target                     = "branch"
  ruleset_type               = "repository"
  enforcement                = "active"
}
