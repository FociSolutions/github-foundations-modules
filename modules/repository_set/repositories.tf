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
  rulesets_by_internal_repository = {
    for repo_name, repo_config in var.internal_repositories : repo_name => {
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
  allow_merge_commit          = each.value.allow_merge_commit
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_squash_merge          = each.value.allow_squash_merge
  merge_commit_title          = each.value.merge_commit_title
  merge_commit_message        = each.value.merge_commit_message
  squash_merge_commit_title   = each.value.squash_merge_commit_title
  squash_merge_commit_message = each.value.squash_merge_commit_message
  dependabot_security_updates = each.value.dependabot_security_updates
  action_secrets              = each.value.action_secrets
  codespace_secrets           = each.value.codespace_secrets
  dependabot_secrets          = each.value.dependabot_secrets
  environments                = each.value.environments
  template_repository         = each.value.template_repository
  license_template            = each.value.license_template
  requires_web_commit_signing = each.value.requires_web_commit_signing
  rulesets                    = lookup(local.rulesets_by_public_repository, each.key, {})
  pages                       = each.value.pages
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
  has_ghas_license            = var.has_ghas_license
  topics                      = each.value.topics
  homepage                    = each.value.homepage
  delete_head_on_merge        = each.value.delete_head_on_merge
  allow_auto_merge            = each.value.allow_auto_merge
  allow_merge_commit          = each.value.allow_merge_commit
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_squash_merge          = each.value.allow_squash_merge
  merge_commit_title          = each.value.merge_commit_title
  merge_commit_message        = each.value.merge_commit_message
  squash_merge_commit_title   = each.value.squash_merge_commit_title
  squash_merge_commit_message = each.value.squash_merge_commit_message
  dependabot_security_updates = each.value.dependabot_security_updates
  action_secrets              = each.value.action_secrets
  codespace_secrets           = each.value.codespace_secrets
  dependabot_secrets          = each.value.dependabot_secrets
  environments                = each.value.environments
  template_repository         = each.value.template_repository
  license_template            = each.value.license_template
  requires_web_commit_signing = each.value.requires_web_commit_signing
  rulesets                    = lookup(local.rulesets_by_private_repository, each.key, {})
  pages                       = each.value.pages
}

module "internal_repositories" {
  source = "../internal_repository"

  for_each = var.internal_repositories

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
  allow_merge_commit          = each.value.allow_merge_commit
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_squash_merge          = each.value.allow_squash_merge
  merge_commit_title          = each.value.merge_commit_title
  merge_commit_message        = each.value.merge_commit_message
  squash_merge_commit_title   = each.value.squash_merge_commit_title
  squash_merge_commit_message = each.value.squash_merge_commit_message
  dependabot_security_updates = each.value.dependabot_security_updates
  action_secrets              = each.value.action_secrets
  codespace_secrets           = each.value.codespace_secrets
  dependabot_secrets          = each.value.dependabot_secrets
  environments                = each.value.environments
  template_repository         = each.value.template_repository
  license_template            = each.value.license_template
  requires_web_commit_signing = each.value.requires_web_commit_signing
  rulesets                    = lookup(local.rulesets_by_internal_repository, each.key, {})
  pages                       = each.value.pages
}
