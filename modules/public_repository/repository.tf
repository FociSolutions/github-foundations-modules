module "repository_base" {
  source = "../repository_base"

  name            = var.name
  description     = var.description
  homepage        = var.homepage
  topics          = var.topics
  visibility      = "public"
  has_downloads   = false
  has_issues      = true
  has_projects    = true
  has_wiki        = true
  has_discussions = true

  repository_team_permissions = var.repository_team_permissions

  default_branch       = var.default_branch
  protected_branches   = var.protected_branches
  delete_head_on_merge = var.delete_head_on_merge
  allow_auto_merge     = var.allow_auto_merge
  requires_web_commit_signing = var.requires_web_commit_signing

  secret_scanning             = true
  secret_scanning_on_push     = true
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
