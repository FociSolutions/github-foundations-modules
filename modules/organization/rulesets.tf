locals {
  all_team_bypassers = toset(concat(
    coalesce(try(var.default_branch_protection_rulesets.bypass_actors.teams, var.default_branch_protection_rulesets.bypass_actors), []),
    [
      for _, ruleset_config in var.rulesets : coalesce(try(ruleset_config.bypass_actors.teams, ruleset_config.bypass_actors), [])
    ]...
  ))

  all_admin_bypassers = toset(concat(
    coalesce(try(var.default_branch_protection_rulesets.bypass_actors.organization_admins, var.default_branch_protection_rulesets.bypass_actors), []),
    [
      for _, ruleset_config in var.rulesets : coalesce(try(ruleset_config.bypass_actors.organization_admins, ruleset_config.bypass_actors), [])
    ]...
  ))

  all_repository_roles_bypassers = toset(concat(
    coalesce(try(var.default_branch_protection_rulesets.bypass_actors.repository_roles, var.default_branch_protection_rulesets.bypass_actors), []),
    [
      for _, ruleset_config in var.rulesets : coalesce(try(ruleset_config.bypass_actors.repository_roles, ruleset_config.bypass_actors), [])
    ]...
  ))

  github_base_role_ids = {
    "maintain" = 2
    "write"    = 4
    "admin"    = 5
  }
}


data "github_team" "branch_ruleset_bypasser" {
  for_each = {
    for team in local.all_team_bypassers : team => team
  }

  slug         = each.value
  summary_only = true
}

data "github_user" "branch_ruleset_bypasser" {
  for_each = {
    for user in local.all_admin_bypassers: user => user
  }

  username = each.value
}

#github_organization_custom_role is actualy repository custom roles. The provider doesn't seem to support custom github organization roles
data "github_organization_custom_role" "branch_ruleset_bypasser" {
  for_each = {
    for role in local.all_repository_roles_bypassers : role => role if !contains(keys(local.github_base_role_ids), role)
  }

  name = each.value
}

resource "github_organization_ruleset" "ruleset" {
  for_each = var.rulesets

  name        = each.key
  target      = each.value.target
  enforcement = each.value.enforcement

  rules {
    creation                = each.value.rules.creation
    update                  = each.value.rules.update
    deletion                = each.value.rules.deletion
    non_fast_forward        = each.value.rules.non_fast_forward
    required_linear_history = each.value.rules.required_linear_history
    required_signatures     = each.value.rules.required_signatures

    dynamic "branch_name_pattern" {
      for_each = each.value.rules.branch_name_pattern != null ? [each.value.rules.branch_name_pattern] : []

      content {
        operator = branch_name_pattern.value.operator
        pattern  = branch_name_pattern.value.pattern
        name     = branch_name_pattern.value.name
        negate   = coalesce(branch_name_pattern.value.negate, false)
      }
    }

    dynamic "tag_name_pattern" {
      for_each = each.value.rules.tag_name_pattern != null ? [each.value.rules.tag_name_pattern] : []

      content {
        operator = tag_name_pattern.value.operator
        pattern  = tag_name_pattern.value.pattern
        name     = tag_name_pattern.value.name
        negate   = coalesce(tag_name_pattern.value.negate, false)
      }
    }

    dynamic "commit_author_email_pattern" {
      for_each = each.value.rules.commit_author_email_pattern != null ? [each.value.rules.commit_author_email_pattern] : []

      content {
        operator = commit_author_email_pattern.value.operator
        pattern  = commit_author_email_pattern.value.pattern
        name     = commit_author_email_pattern.value.name
        negate   = coalesce(commit_author_email_pattern.value.negate, false)
      }
    }

    dynamic "commit_message_pattern" {
      for_each = each.value.rules.commit_message_pattern != null ? [each.value.rules.commit_message_pattern] : []

      content {
        operator = commit_message_pattern.value.operator
        pattern  = commit_message_pattern.value.pattern
        name     = commit_message_pattern.value.name
        negate   = coalesce(commit_message_pattern.value.negate, false)
      }
    }

    dynamic "committer_email_pattern" {
      for_each = each.value.rules.committer_email_pattern != null ? [each.value.rules.committer_email_pattern] : []

      content {
        operator = committer_email_pattern.value.operator
        pattern  = committer_email_pattern.value.pattern
        name     = committer_email_pattern.value.name
        negate   = coalesce(committer_email_pattern.value.negate, false)
      }
    }

    dynamic "pull_request" {
      for_each = each.value.rules.pull_request != null ? [each.value.rules.pull_request] : []

      content {
        dismiss_stale_reviews_on_push     = coalesce(pull_request.value.dismiss_stale_reviews_on_push, false)
        require_code_owner_review         = coalesce(pull_request.value.require_code_owner_review, false)
        require_last_push_approval        = coalesce(pull_request.value.require_last_push_approval, false)
        required_approving_review_count   = coalesce(pull_request.value.required_approving_review_count, 0)
        required_review_thread_resolution = coalesce(pull_request.value.required_review_thread_resolution, false)
      }
    }

    dynamic "required_status_checks" {
      for_each = each.value.rules.required_status_checks != null ? [each.value.rules.required_status_checks] : []

      content {
        dynamic "required_check" {
          for_each = required_status_checks.value.required_check

          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }

        strict_required_status_checks_policy = required_status_checks.value.strict_required_status_check_policy
      }
    }

    dynamic "required_workflows" {
      for_each = each.value.rules.required_workflows != null ? [each.value.rules.required_workflows] : []

      content {

        dynamic "required_workflow" {
          for_each = required_workflows.value.required_workflows

          content {
            repository_id = required_workflow.value.repository_id
            path          = required_workflow.value.path
            ref           = coalesce(required_workflow.value.ref, "main")
          }
        }
      }
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.repository_roles, [])) : []

    content {
      actor_id    = lookup(local.github_base_role_ids, bypass_actors.value.role, data.github_organization_custom_role.branch_ruleset_bypasser["${bypass_actors.value.role}"].id)
      actor_type  = "RepositoryRole"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.teams, [])) : []

    content {
      actor_id    = data.github_team.branch_ruleset_bypasser["${bypass_actors.value.team}"].id
      actor_type  = "Team"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.integrations, [])) : []

    content {
      actor_id    = bypass_actors.value.installation_id
      actor_type  = "Integration"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.organization_admins, [])) : []

    content {
      actor_id    = data.github_user.branch_ruleset_bypasser["${bypass_actors.value.user}"].id
      actor_type  = "OrganizationAdmin"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "conditions" {
    for_each = each.value.conditions != null ? [each.value.conditions] : []

    content {
      ref_name {
        include = conditions.value.ref_name.include
        exclude = conditions.value.ref_name.exclude
      }

      dynamic "repository_name" {
        for_each = conditions.value.repository_name != null ? [conditions.value.repository_name] : []

        content {
          include = repository_name.value.include
          exclude = repository_name.value.exclude
        }
      }
    }
  }
}

resource "github_organization_ruleset" "base_default_branch_protection" {
  count       = var.default_branch_protection_rulesets.base_protection ? 1 : 0
  name        = "base_default_branch_protection"
  target      = "branch"
  enforcement = var.default_branch_protection_rulesets.base_protection.enforcement

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true
    pull_request {
      require_last_push_approval = true
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.teams, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_team.branch_ruleset_bypasser["${bypass_actors.value.team}"].id
      actor_type  = "Team"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.integrations, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = bypass_actors.value.installation_id
      actor_type  = "Integration"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.organization_admins, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_user.branch_ruleset_bypasser["${bypass_actors.value.user}"].id
      actor_type  = "OrganizationAdmin"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.repository_roles, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = lookup(local.github_base_role_ids, bypass_actors.value.role, data.github_organization_custom_role.branch_ruleset_bypasser["${bypass_actors.value.role}"].id)
      actor_type  = "RepositoryRole"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }
}

resource "github_organization_ruleset" "minimum_approvals" {
  count       = var.default_branch_protection_rulesets.minimum_approvals ? 1 : 0
  name        = "minimum_approvals"
  target      = "branch"
  enforcement = var.default_branch_protection_rulesets.minimum_approvals.enforcement

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    pull_request {
      required_approving_review_count = var.default_branch_protection_rulesets.minimum_approvals.approvals_required
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.teams, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_team.branch_ruleset_bypasser["${bypass_actors.value.team}"].id
      actor_type  = "Team"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.integrations, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = bypass_actors.value.installation_id
      actor_type  = "Integration"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.organization_admins, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_user.branch_ruleset_bypasser["${bypass_actors.value.user}"].id
      actor_type  = "OrganizationAdmin"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.repository_roles, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = lookup(local.github_base_role_ids, bypass_actors.value.role, data.github_organization_custom_role.branch_ruleset_bypasser["${bypass_actors.value.role}"].id)
      actor_type  = "RepositoryRole"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }
}

resource "github_organization_ruleset" "dismiss_stale_reviews" {
  count       = var.default_branch_protection_rulesets.dismiss_stale_reviews ? 1 : 0
  name        = "dismiss_stale_reviews"
  target      = "branch"
  enforcement = var.default_branch_protection_rulesets.dismiss_stale_reviews.enforcement

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    pull_request {
      dismiss_stale_reviews_on_push = true
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.teams, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_team.branch_ruleset_bypasser["${bypass_actors.value.team}"].id
      actor_type  = "Team"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.integrations, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = bypass_actors.value.installation_id
      actor_type  = "Integration"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.organization_admins, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_user.branch_ruleset_bypasser["${bypass_actors.value.user}"].id
      actor_type  = "OrganizationAdmin"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.repository_roles, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = lookup(local.github_base_role_ids, bypass_actors.value.role, data.github_organization_custom_role.branch_ruleset_bypasser["${bypass_actors.value.role}"].id)
      actor_type  = "RepositoryRole"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }
}

resource "github_organization_ruleset" "require_signatures" {
  count       = var.default_branch_protection_rulesets.require_signatures ? 1 : 0
  name        = "require_signatures"
  target      = "branch"
  enforcement = var.default_branch_protection_rulesets.require_signatures.enforcement

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    required_signatures = true
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.teams, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_team.branch_ruleset_bypasser["${bypass_actors.value.team}"].id
      actor_type  = "Team"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.integrations, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = bypass_actors.value.installation_id
      actor_type  = "Integration"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.organization_admins, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = data.github_user.branch_ruleset_bypasser["${bypass_actors.value.user}"].id
      actor_type  = "OrganizationAdmin"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = coalesce(try(var.default_branch_protection_rulesets.bypass_actors.repository_roles, var.default_branch_protection_rulesets.bypass_actors), [])

    content {
      actor_id    = lookup(local.github_base_role_ids, bypass_actors.value.role, data.github_organization_custom_role.branch_ruleset_bypasser["${bypass_actors.value.role}"].id)
      actor_type  = "RepositoryRole"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }
}
