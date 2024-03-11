locals {
  branch_ruleset_team_bypassers = merge([
    for ruleset, ruleset_config in var.branch_rulesets : {
      for bypasser in ruleset_config.bypass_actors.teams : "${ruleset}:${bypasser.team}" => bypasser.team
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.teams != null
  ]...)

  branch_ruleset_admin_bypassers = merge([
    for ruleset, ruleset_config in var.branch_rulesets : {
      for bypasser in ruleset_config.bypass_actors.organization_admins : "${ruleset}:${bypasser.user}" => bypasser.user
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.organization_admins != null
  ]...)

  branch_ruleset_custom_repository_roles = merge([
    for ruleset, ruleset_config in var.branch_rulesets : {
      for bypasser in ruleset_config.bypass_actors.repository_roles : "${ruleset}:${bypasser.role}" => bypasser.role if !contains(keys(local.github_base_role_ids), bypasser.role)
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.repository_roles != null
  ]...)

  github_base_role_ids = {
    "maintain" = 2
    "write" = 4
    "admin" = 5
  }
}


data "github_team" "branch_ruleset_bypasser" {
  for_each = local.branch_ruleset_team_bypassers

  slug         = each.value
  summary_only = true
}

data "github_user" "branch_ruleset_bypasser" {
  for_each = local.branch_ruleset_admin_bypassers

  username = each.value
}

#github_organization_custom_role is actualy repository custom roles. The provider doesn't seem to support custom github organization roles
data "github_organization_custom_role" "branch_ruleset_bypasser" {
    for_each = local.branch_ruleset_custom_repository_roles

    name = each.value
}

resource "github_organization_ruleset" "branch_ruleset" {
  for_each = var.branch_rulesets

  name        = each.key
  target      = "branch"
  enforcement = coalesce(each.value.disable, false) ? "disabled" : "active" #Might want this to just be a string so it can also be set to evaluate

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.repository_roles, [])) : []

    content {
      actor_id    = lookup(local.github_base_role_ids, bypass_actors.value.role, data.github_organization_custom_role.branch_ruleset_bypasser["${each.key}:${bypass_actors.value.role}"].id)
      actor_type  = "RepositoryRole"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }

  rules {

  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.teams, [])) : []

    content {
      actor_id    = data.github_team.branch_ruleset_bypasser["${each.key}:${bypass_actors.value.team}"].id
      actor_type  = "Team"
      bypass_mode =coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
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
      actor_id    = data.github_user.branch_ruleset_bypasser["${each.key}:${bypass_actors.value.user}"].id
      actor_type  = "OrganizationAdmin"
      bypass_mode = coalesce(bypass_actors.value.always_bypass, false) ? "always" : "pull_request"
    }
  }
}