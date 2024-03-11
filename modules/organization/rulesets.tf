locals {
  branch_ruleset_team_bypassers = merge([
    for ruleset, ruleset_config in var.branch_rulesets : {
      for team_slug in ruleset_config.bypass_actors.teams : "${ruleset}:${team_slug}" => team_slug
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.teams != null
  ]...)

  branch_ruleset_admin_bypassers = merge([
    for ruleset, ruleset_config in var.branch_rulesets : {
      for user in ruleset_config.bypass_actors.organization_admins : "${ruleset}:${user}" => user
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.organization_admins != null
  ]...)

  branch_ruleset_custom_repository_roles = merge([
    for ruleset, ruleset_config in var.branch_rulesets : {
      for role in ruleset_config.bypass_actors.repository_roles : "${ruleset}:${role}" => role
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.repository_roles != null && !contains(keys(local.github_base_role_ids), role)
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
      actor_id    = lookup(local.github_base_role_ids, bypass_actors.value, data.github_organization_custom_role.branch_ruleset_bypasser["${each.key}:${bypass_actors.value}"])
      actor_type  = "RepositoryRole"
      bypass_mode = "always"
    }
  }

  rules {

  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.teams, [])) : []

    content {
      actor_id    = data.github_team.branch_ruleset_bypasser["${each.key}:${bypass_actors.value}"].id
      actor_type  = "Team"
      bypass_mode = "always" #Todo make configurable
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.integrations, [])) : []

    content {
      actor_id    = bypass_actors.value
      actor_type  = "Integration"
      bypass_mode = "always"
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.organization_admins, [])) : []

    content {
      actor_id    = data.github_user.branch_ruleset_bypasser["${each.key}:${bypass_actors.value}"].id
      actor_type  = "OrganizationAdmin"
      bypass_mode = "always"
    }
  }
}