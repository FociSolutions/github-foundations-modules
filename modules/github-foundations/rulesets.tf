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

  ref_name_inclusions        = ["~DEFAULT"]
  repository_name_inclusions = [github_repository.bootstrap_repo.name, github_repository.organizations_repo.name]
}

module "terraform_required_workflow_ruleset" {
  source = "../ruleset"

  name         = "Foundation Repositories Terraform Required Workflow Ruleset"
  enforcement  = "active"
  target       = "branch"
  ruleset_type = "organization"

  rules = {
    required_workflows = {
      required_workflows = [
        {
          repository_id = github_repository.organizations_repo.id
          path          = ".github/workflows/on-pull-and-push.yaml"
          ref           = "main"
        }
      ]
    }
  }

  ref_name_inclusions        = ["~DEFAULT"]
  repository_name_inclusions = [github_repository.organizations_repo.name]
}
