locals {
  all_team_bypassers = toset(flatten(
    [
      for _, ruleset_config in var.rulesets : coalesce(try(ruleset_config.bypass_actors.teams, []), [])
    ]
  ))

  all_admin_bypassers = toset(flatten(
    [
      for _, ruleset_config in var.rulesets : coalesce(try(ruleset_config.bypass_actors.organization_admins, []), [])
    ]
  ))

  all_repository_roles_bypassers = toset(flatten(
    [
      for _, ruleset_config in var.rulesets : coalesce(try(ruleset_config.bypass_actors.repository_roles, []), [])
    ]
  ))

  github_base_role_ids = {
    "maintain" = 2
    "write"    = 4
    "admin"    = 5
  }
}


data "github_team" "branch_ruleset_bypasser" {
  for_each = {
    for bypasser in local.all_team_bypassers : bypasser.team => bypasser.team
  }

  slug         = each.value
  summary_only = true
}

data "github_user" "branch_ruleset_bypasser" {
  for_each = {
    for bypasser in local.all_admin_bypassers : bypasser.user => bypasser.user
  }

  username = each.value
}

data "github_organization_custom_role" "branch_ruleset_bypasser" {
  for_each = {
    for bypasser in local.all_repository_roles_bypassers : bypasser.role => bypasser.role
  }

  name = each.value
}

module "ruleset" {
  source = "../ruleset"

  for_each = var.rulesets

  name        = each.key
  target      = each.value.target
  enforcement = each.value.enforcement

  ruleset_type = "repository"

  rules = {
    creation                      = each.value.rules.creation
    update                        = each.value.rules.update
    deletion                      = each.value.rules.deletion
    non_fast_forward              = each.value.rules.non_fast_forward
    required_linear_history       = each.value.rules.required_linear_history
    required_signatures           = each.value.rules.required_signatures
    update_allows_fetch_and_merge = each.value.rules.update_allows_fetch_and_merge

    branch_name_pattern              = each.value.rules.branch_name_pattern
    tag_name_pattern                 = each.value.rules.tag_name_pattern
    commit_author_email_pattern      = each.value.rules.commit_author_email_pattern
    commit_message_pattern           = each.value.rules.commit_message_pattern
    committer_email_pattern          = each.value.rules.committer_email_pattern
    pull_request                     = each.value.rules.pull_request
    required_status_checks           = each.value.rules.required_status_checks
    required_deployment_environments = each.value.rules.required_deployment_environments
  }

  bypass_actors = {
    repository_roles = [for bypasser in try(toset(coalesce(each.value.bypass_actors.repository_roles, [])), []) : {
      role_id       = lookup(local.github_base_role_ids, bypasser.role, data.github_organization_custom_role.branch_ruleset_bypasser["${bypasser.role}"].id)
      always_bypass = bypasser.always_bypass
    }]
    teams = [for bypasser in try(toset(coalesce(each.value.bypass_actors.teams, [])), []) : {
      team_id       = data.github_team.branch_ruleset_bypasser["${bypasser.team}"].id
      always_bypass = bypasser.always_bypass
    }]
    organization_admins = [for bypasser in try(toset(coalesce(each.value.bypass_actors.organization_admins, [])), []) : {
      user_id       = data.github_user.branch_ruleset_bypasser["${bypasser.user}"].id
      always_bypass = bypasser.always_bypass
    }]
    integrations = try(each.value.bypass_actors.repository_roles, [])
  }

  ref_name_inclusions        = each.value.conditions.ref_name.include
  ref_name_exclusions        = each.value.conditions.ref_name.exclude
}