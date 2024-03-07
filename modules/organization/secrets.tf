module "organization_secrets" {
  source = "../organization_secrets"

  organization_action_secrets     = var.actions_secrets
  organization_codespace_secrets  = var.codespaces_secrets
  organization_dependabot_secrets = var.dependabot_secrets
}