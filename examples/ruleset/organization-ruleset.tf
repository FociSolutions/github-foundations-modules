module "github_org_ruleset" {
  source = "../../modules/ruleset"

  name = "org-wide-main-pr-rules"
  bypass_actors = {
    organization_admins = [
      { user_id = "admin_id", always_bypass = true }
    ]
  }
  rules = {
    branch_name_pattern = {
      operator = "equals",
      pattern  = "main",
      name     = "Main Branch Protection",
      negate   = false
    },
    pull_request = {
      dismiss_stale_reviews_on_push   = true,
      require_code_owner_review       = true,
      required_approving_review_count = 1
    }
  }
  target       = "branch"
  ruleset_type = "organization"
  enforcement  = "active"
}
