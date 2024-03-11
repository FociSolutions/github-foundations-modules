locals {
  branch_ruleset_team_bypassers = [
    for ruleset, ruleset_config in var.branch_rulesets : {
      for team_slug in ruleset_config.bypass_actors.teams : "${ruleset}:${team_slug}" => team_slug
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.teams != null
  ]

  branch_ruleset_app_bypassers = [
    for ruleset, ruleset_config in var.branch_rulesets : {
      for app_slug in ruleset_config.bypass_actors.integrations : "${ruleset}:${app_slug}" => app_slug
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.integrations != null
  ]

  branch_ruleset_admin_bypassers = [
    for ruleset, ruleset_config in var.branch_rulesets : {
      for user in ruleset_config.bypass_actors.organization_admins : "${ruleset}:${user}" => user
    } if ruleset_config.bypass_actors != null && ruleset_config.bypass_actors.organization_admins != null
  ]
}


data "github_team" "branch_ruleset_bypasser" {
  for_each = local.branch_ruleset_team_bypassers

  slug         = each.value
  summary_only = true
}

data "github_app" "branch_ruleset_bypasser" {
  for_each = local.branch_ruleset_app_bypassers

  slug = each.value
}

data "github_user" "branch_ruleset_bypasser" {
  for_each = local.branch_ruleset_admin_bypassers

  username = each.value
}

resource "organization_ruleset" "branch_ruleset" {
  for_each = var.branch_ruleset

  name        = each.key
  target      = "branch"
  enforcement = each.value.disable != null && each.value.disable ? "disabled" : "active" #Might want this to just be a string so it can also be set to evaluate

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors != null ? toset(coalesce(each.value.bypass_actors.repository_roles, [])) : []

    content {
      actor_id    = bypass_actors.value
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
      actor_id    = data.github_app.branch_ruleset_bypasser["${each.key}:${bypass_actors.value}"].node_id
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