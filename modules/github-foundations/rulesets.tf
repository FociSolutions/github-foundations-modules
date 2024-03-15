module "base_ruleset" {
  source = "../ruleset"

  name         = "Foundation Repositories Base Ruleset"
  enforcement  = "active"
  target       = "branch"
  ruleset_type = "organization"

  rules = {
    pull_request = {
      dismiss_stale_reviews_on_push   = true
      require_last_push_approval      = true
      required_approving_review_count = 1
    }
  }

  ref_name_inclusions        = ["~DEFAULT_BRANCH"]
  repository_name_inclusions = [github_repository.bootstrap_repo.name, github_repository.organizations_repo.name]
}