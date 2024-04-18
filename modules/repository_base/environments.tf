locals {
  env_deployment_branch_patterns = {
    for env_name, env in var.environments : env_name => env.deployment_branch_policy.branch_patterns if env.deployment_branch_policy != null
  }

  deployment_policy_configurations = merge([
    for env_name, branch_patterns in local.env_deployment_branch_patterns : {
      for pattern in branch_patterns : "${env_name}:${pattern}" => {
        pattern     = pattern,
        environment = env_name
      }
    }
  ]...)
}

resource "github_repository_environment" "environment" {
  for_each            = var.environments
  repository          = github_repository.repository.name
  environment         = each.key
  wait_timer          = each.value.wait_timer
  can_admins_bypass   = each.value.can_admins_bypass
  prevent_self_review = each.value.prevent_self_review

  dynamic "reviewers" {
    for_each = each.value.reviewers != null ? toset([each.value.reviewers]) : []
    content {
      teams = reviewers.value.teams
      users = reviewers.value.users
    }
  }

  dynamic "deployment_branch_policy" {
    for_each = each.value.deployment_branch_policy != null ? toset([each.value.deployment_branch_policy]) : []
    content {
      protected_branches     = deployment_branch_policy.value.protected_branches
      custom_branch_policies = deployment_branch_policy.value.custom_branch_policies
    }
  }
}

resource "github_repository_environment_deployment_policy" "deployment_policy" {
  for_each       = local.deployment_policy_configurations
  repository     = github_repository.repository.name
  environment    = github_repository_environment.environment["${each.value.environment}"].environment
  branch_pattern = each.value.pattern
}
