locals {
  rulesets_by_public_repository = {
    for repo_name, repo_config in var.public_repositories : repo_name => {
      for ruleset_name, ruleset_config in var.rulesets : ruleset_name => ruleset_config if contains(ruleset_config.repositories, repo_name)
    }
  }
  rulesets_by_private_repository = {
    for repo_name, repo_config in var.private_repositories : repo_name => {
      for ruleset_name, ruleset_config in var.rulesets : ruleset_name => ruleset_config if contains(ruleset_config.repositories, repo_name)
    }
  }
}

module "public_repositories" {
  source = "../public_repository"

  for_each = var.public_repositories

  name                        = each.key
  repository_team_permissions = merge(var.default_repository_team_permissions, coalesce(each.value.repository_team_permissions_override, {}))
  repository_user_permissions = coalesce(each.value.user_permissions, {})
  description                 = each.value.description
  default_branch              = each.value.default_branch
  protected_branches          = each.value.protected_branches
  advance_security            = each.value.advance_security
  topics                      = each.value.topics
  homepage                    = each.value.homepage
  delete_head_on_merge        = each.value.delete_head_on_merge
  allow_auto_merge            = each.value.allow_auto_merge
  dependabot_security_updates = each.value.dependabot_security_updates
  action_secrets              = each.value.action_secrets
  codespace_secrets           = each.value.codespace_secrets
  dependabot_secrets          = each.value.dependabot_secrets
  environments                = each.value.environments
  template_repository         = each.value.template_repository
  license_template            = each.value.license_template
  requires_web_commit_signing = each.value.requires_web_commit_signing
  rulesets                    = lookup(local.rulesets_by_public_repository, each.key, {})
}

module "private_repositories" {
  source = "../private_repository"

  for_each = var.private_repositories

  name                        = each.key
  repository_team_permissions = merge(var.default_repository_team_permissions, coalesce(each.value.repository_team_permissions_override, {}))
  repository_user_permissions = coalesce(each.value.user_permissions, {})
  description                 = each.value.description
  default_branch              = each.value.default_branch
  protected_branches          = each.value.protected_branches
  advance_security            = each.value.advance_security
  topics                      = each.value.topics
  homepage                    = each.value.homepage
  delete_head_on_merge        = each.value.delete_head_on_merge
  allow_auto_merge            = each.value.allow_auto_merge
  dependabot_security_updates = each.value.dependabot_security_updates
  action_secrets              = each.value.action_secrets
  codespace_secrets           = each.value.codespace_secrets
  dependabot_secrets          = each.value.dependabot_secrets
  environments                = each.value.environments
  template_repository         = each.value.template_repository
  license_template            = each.value.license_template
  requires_web_commit_signing = each.value.requires_web_commit_signing
  rulesets                    = lookup(local.rulesets_by_private_repository, each.key, {})

}
