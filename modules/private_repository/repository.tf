locals {
  enable_secret_scanning = var.has_ghas_license
}

module "repository_base" {
  source = "../repository_base"

  name            = var.name
  description     = var.description
  homepage        = var.homepage
  topics          = var.topics
  visibility      = "private"
  has_downloads   = false
  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = false

  repository_team_permissions = var.repository_team_permissions
  repository_user_permissions = var.repository_user_permissions

  default_branch              = var.default_branch
  protected_branches          = var.protected_branches
  delete_head_on_merge        = var.delete_head_on_merge
  allow_auto_merge            = var.allow_auto_merge
  allow_merge_commit          = var.allow_merge_commit
  allow_rebase_merge          = var.allow_rebase_merge
  allow_squash_merge          = var.allow_squash_merge
  squash_merge_commit_message = var.squash_merge_commit_message
  squash_merge_commit_title   = var.squash_merge_commit_title
  merge_commit_message        = var.merge_commit_message
  merge_commit_title          = var.merge_commit_title
  requires_web_commit_signing = var.requires_web_commit_signing
  pages                       = var.pages

  secret_scanning             = local.enable_secret_scanning
  secret_scanning_on_push     = local.enable_secret_scanning
  has_vulnerability_alerts    = true
  advance_security            = var.advance_security
  dependabot_security_updates = var.dependabot_security_updates

  codespace_secrets  = var.codespace_secrets
  dependabot_secrets = var.dependabot_secrets
  action_secrets     = var.action_secrets

  environments = var.environments

  template_repository = var.template_repository
  license_template    = var.license_template

  rulesets = var.rulesets
}
