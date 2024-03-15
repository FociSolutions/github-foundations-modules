resource "github_repository_ruleset" "ruleset" {
  count       = var.ruleset_type == "repository" ? 1 : 0
  name        = var.name
  target      = var.target
  enforcement = var.enforcement

  dynamic "conditions" {
    for_each = length(concat(var.ref_name_inclusions, var.ref_name_exclusions)) > 0 ? [1] : []
    content {
      ref_name {
        include = var.ref_name_inclusions
        exclude = var.ref_name_exclusions
      }
    }
  }

  rules {
    creation                      = var.rules.creation
    update                        = var.rules.update
    deletion                      = var.rules.deletion
    non_fast_forward              = var.rules.non_fast_forward
    required_linear_history       = var.rules.required_linear_history
    required_signatures           = var.rules.required_signatures
    update_allows_fetch_and_merge = var.rules.update_allows_fetch_and_merge

    dynamic "branch_name_pattern" {
      for_each = var.rules.branch_name_pattern != null ? [var.rules.branch_name_pattern] : []

      content {
        operator = branch_name_pattern.value.operator
        pattern  = branch_name_pattern.value.pattern
        name     = branch_name_pattern.value.name
        negate   = coalesce(branch_name_pattern.value.negate, false)
      }
    }

    dynamic "tag_name_pattern" {
      for_each = var.rules.tag_name_pattern != null ? [var.rules.tag_name_pattern] : []

      content {
        operator = tag_name_pattern.value.operator
        pattern  = tag_name_pattern.value.pattern
        name     = tag_name_pattern.value.name
        negate   = coalesce(tag_name_pattern.value.negate, false)
      }
    }

    dynamic "commit_author_email_pattern" {
      for_each = var.rules.commit_author_email_pattern != null ? [var.rules.commit_author_email_pattern] : []

      content {
        operator = commit_author_email_pattern.value.operator
        pattern  = commit_author_email_pattern.value.pattern
        name     = commit_author_email_pattern.value.name
        negate   = coalesce(commit_author_email_pattern.value.negate, false)
      }
    }

    dynamic "commit_message_pattern" {
      for_each = var.rules.commit_message_pattern != null ? [var.rules.commit_message_pattern] : []

      content {
        operator = commit_message_pattern.value.operator
        pattern  = commit_message_pattern.value.pattern
        name     = commit_message_pattern.value.name
        negate   = coalesce(commit_message_pattern.value.negate, false)
      }
    }

    dynamic "committer_email_pattern" {
      for_each = var.rules.committer_email_pattern != null ? [var.rules.committer_email_pattern] : []

      content {
        operator = committer_email_pattern.value.operator
        pattern  = committer_email_pattern.value.pattern
        name     = committer_email_pattern.value.name
        negate   = coalesce(committer_email_pattern.value.negate, false)
      }
    }

    dynamic "pull_request" {
      for_each = var.rules.pull_request != null ? [var.rules.pull_request] : []

      content {
        dismiss_stale_reviews_on_push     = coalesce(pull_request.value.dismiss_stale_reviews_on_push, false)
        require_code_owner_review         = coalesce(pull_request.value.require_code_owner_review, false)
        require_last_push_approval        = coalesce(pull_request.value.require_last_push_approval, false)
        required_approving_review_count   = coalesce(pull_request.value.required_approving_review_count, 0)
        required_review_thread_resolution = coalesce(pull_request.value.required_review_thread_resolution, false)
      }
    }

    dynamic "required_status_checks" {
      for_each = var.rules.required_status_checks != null ? [var.rules.required_status_checks] : []

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

    dynamic "required_deployments" {
      for_each = var.rules.required_deployment_environments != null ? [var.rules.required_deployment_environments] : []

      content {
        required_deployment_environments = required_deployments.value
      }
    }
  }

  dynamic "bypass_actors" {
    for_each = var.bypass_actors.repository_roles != null ? toset(coalesce(var.bypass_actors.repository_roles, [])) : []

    content {
      actor_id    = bypass_actors.value.role_id
      actor_type  = "RepositoryRole"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }
  dynamic "bypass_actors" {
    for_each = var.bypass_actors != null ? toset(coalesce(var.bypass_actors.teams, [])) : []

    content {
      actor_id    = bypass_actors.value.team_id
      actor_type  = "Team"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = var.bypass_actors != null ? toset(coalesce(var.bypass_actors.integrations, [])) : []

    content {
      actor_id    = bypass_actors.value.installation_id
      actor_type  = "Integration"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  dynamic "bypass_actors" {
    for_each = var.bypass_actors != null ? toset(coalesce(var.bypass_actors.organization_admins, [])) : []

    content {
      actor_id    = bypass_actors.value.user_id
      actor_type  = "OrganizationAdmin"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }
}