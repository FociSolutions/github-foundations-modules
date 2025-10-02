mock_provider "github" {}


variables {

  name         = "ruleset_name"
  ruleset_type = "repository"
  target       = "tag"
  enforcement  = "disabled"

  ref_name_inclusions = ["main"]
  ref_name_exclusions = ["feature/*"]

  rules = {
    creation                      = true
    update                        = false
    deletion                      = true
    non_fast_forward              = false
    required_linear_history       = true
    required_signatures           = false
    update_allows_fetch_and_merge = true

    branch_name_pattern = {
      operator = "regex"
      pattern  = "pattern"
      name     = "branch_name"
      negate   = false
    }
    commit_author_email_pattern = {
      operator = "regex"
      pattern  = "pattern"
      name     = "commit_author_email"
      negate   = false
    }
    commit_message_pattern = {
      operator = "regex"
      pattern  = "pattern"
      name     = "commit_message"
      negate   = false
    }
    committer_email_pattern = {
      operator = "regex"
      pattern  = "pattern"
      name     = "committer_email"
      negate   = false
    }
    pull_request = {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = false
      require_last_push_approval        = true
      required_approving_review_count   = 2
      required_review_thread_resolution = false
    }
    required_status_checks = {
      required_check = [
        {
          context        = "context"
          integration_id = 555555
        },
        {
          context        = "context2"
          integration_id = 666666
        }
      ]
      strict_required_status_check_policy = true
    }
    required_deployment_environments = ["env1", "env2"]
  }

  bypass_actors = {
    repository_roles = [
      {
        role_id     = 111111
        bypass_mode = false
      }
    ]
    teams = [
      {
        team_id       = 222222
        always_bypass = true
      }
    ]
    integrations = [
      {
        installation_id = 333333
        always_bypass   = false
      }
    ]
    organization_admin = {
      always_bypass = true
    }
  }
}

# Test the ruleset creation
run "create_ruleset_test" {
  command = apply

  assert {
    condition     = github_repository_ruleset.ruleset[0].name == var.name
    error_message = "The ruleset name is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].target == var.target
    error_message = "The target type is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].enforcement == var.enforcement
    error_message = "The enforcement mode is incorrect."
  }
}

# Test the ruleset conditions
run "ruleset_conditions_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].conditions[0].ref_name[0].include[0] == var.ref_name_inclusions[0]
    error_message = "The ref name inclusion is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].conditions[0].ref_name[0].exclude[0] == var.ref_name_exclusions[0]
    error_message = "The ref name exclusion is incorrect."
  }
}

# Test the ruleset rules
run "ruleset_rules_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].creation == var.rules.creation
    error_message = "The creation rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].update == var.rules.update
    error_message = "The update rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].deletion == var.rules.deletion
    error_message = "The deletion rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].non_fast_forward == var.rules.non_fast_forward
    error_message = "The non-fast-forward rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].required_linear_history == var.rules.required_linear_history
    error_message = "The required linear history rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].required_signatures == var.rules.required_signatures
    error_message = "The required signatures rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].update_allows_fetch_and_merge == var.rules.update_allows_fetch_and_merge
    error_message = "The update allows fetch and merge rule is incorrect."
  }
}

# Test the branch name pattern rule
run "ruleset_branch_name_pattern_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].branch_name_pattern[0].operator == var.rules.branch_name_pattern.operator
    error_message = "The branch name pattern operator is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].branch_name_pattern[0].pattern == var.rules.branch_name_pattern.pattern
    error_message = "The branch name pattern is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].branch_name_pattern[0].name == var.rules.branch_name_pattern.name
    error_message = "The branch name pattern name is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].branch_name_pattern[0].negate == var.rules.branch_name_pattern.negate
    error_message = "The branch name pattern negate is incorrect."
  }
}

# Test the commit author email pattern rule
run "ruleset_commit_author_email_pattern_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_author_email_pattern[0].operator == var.rules.commit_author_email_pattern.operator
    error_message = "The commit author email pattern operator is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_author_email_pattern[0].pattern == var.rules.commit_author_email_pattern.pattern
    error_message = "The commit author email pattern is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_author_email_pattern[0].name == var.rules.commit_author_email_pattern.name
    error_message = "The commit author email pattern name is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_author_email_pattern[0].negate == var.rules.commit_author_email_pattern.negate
    error_message = "The commit author email pattern negate is incorrect."
  }
}

# Test the commit message pattern rule
run "ruleset_commit_message_pattern_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_message_pattern[0].operator == var.rules.commit_message_pattern.operator
    error_message = "The commit message pattern operator is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_message_pattern[0].pattern == var.rules.commit_message_pattern.pattern
    error_message = "The commit message pattern is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_message_pattern[0].name == var.rules.commit_message_pattern.name
    error_message = "The commit message pattern name is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].commit_message_pattern[0].negate == var.rules.commit_message_pattern.negate
    error_message = "The commit message pattern negate is incorrect."
  }
}

# Test the committer email pattern rule
run "ruleset_committer_email_pattern_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].committer_email_pattern[0].operator == var.rules.committer_email_pattern.operator
    error_message = "The committer email pattern operator is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].committer_email_pattern[0].pattern == var.rules.committer_email_pattern.pattern
    error_message = "The committer email pattern is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].committer_email_pattern[0].name == var.rules.committer_email_pattern.name
    error_message = "The committer email pattern name is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].committer_email_pattern[0].negate == var.rules.committer_email_pattern.negate
    error_message = "The committer email pattern negate is incorrect."
  }
}

# Test the pull request rule
run "ruleset_pull_request_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].pull_request[0].dismiss_stale_reviews_on_push == var.rules.pull_request.dismiss_stale_reviews_on_push
    error_message = "The pull request dismiss stale reviews on push rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].pull_request[0].require_code_owner_review == var.rules.pull_request.require_code_owner_review
    error_message = "The pull request require code owner reviews rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].pull_request[0].require_last_push_approval == var.rules.pull_request.require_last_push_approval
    error_message = "The pull request require last push approval rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].pull_request[0].required_approving_review_count == var.rules.pull_request.required_approving_review_count
    error_message = "The pull request required approving review count rule is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].pull_request[0].required_review_thread_resolution == var.rules.pull_request.required_review_thread_resolution
    error_message = "The pull request required review thread resolution rule is incorrect."
  }
}

# Test the required status checks rule
run "ruleset_required_status_checks_test" {
  # Can't test the required checks because the tf test framework doesn't
  # support lists of objects yet.
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].required_status_checks[0].strict_required_status_checks_policy == var.rules.required_status_checks.strict_required_status_check_policy
    error_message = "The required status checks context is incorrect."
  }
}

# Test the required deployments rule
run "ruleset_required_deployments_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].required_deployments[0].required_deployment_environments[0] == var.rules.required_deployment_environments[0]
    error_message = "The required deployment environments is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].rules[0].required_deployments[0].required_deployment_environments[1] == var.rules.required_deployment_environments[1]
    error_message = "The required deployment environments is incorrect."
  }
}

# Test the repository bypass actors
run "bypass_actor_repository_roles_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[0].actor_id == tonumber(var.bypass_actors.repository_roles[0].role_id)
    error_message = "The bypass actor role id is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[0].bypass_mode == "pull_request"
    error_message = "The bypass actor role bypass mode is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[0].actor_type == "RepositoryRole"
    error_message = "The bypass actor type is incorrect."
  }
}

# Test the Team bypass actors
run "bypass_actor_teams_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[1].actor_id == tonumber(var.bypass_actors.teams[0].team_id)
    error_message = "The bypass actor team id is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[1].bypass_mode == "always"
    error_message = "The bypass actor team bypass mode is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[1].actor_type == "Team"
    error_message = "The bypass actor type is incorrect."
  }
}

# Test the Integration bypass actors
run "bypass_actor_integrations_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[2].actor_id == tonumber(var.bypass_actors.integrations[0].installation_id)
    error_message = "The bypass actor integration id is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[2].bypass_mode == "pull_request"
    error_message = "The bypass actor integration bypass mode is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[2].actor_type == "Integration"
    error_message = "The bypass actor type is incorrect."
  }
}

# Test the Organization Admin bypass actors
run "bypass_actor_organization_admins_test" {
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[3].actor_id == 1
    error_message = "The bypass actor organization admin id is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[3].bypass_mode == "always"
    error_message = "The bypass actor organization admin bypass mode is incorrect."
  }
  assert {
    condition     = github_repository_ruleset.ruleset[0].bypass_actors[3].actor_type == "OrganizationAdmin"
    error_message = "The bypass actor type is incorrect."
  }
}
