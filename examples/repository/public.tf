module "public_github_repository" {
  source = "../../modules/public_repository"

  name           = "example-public-repo"
  description    = "An example public GitHub repository created with Terraform."
  default_branch = "main"
  repository_team_permissions = {
    "dev-team" = "push",
    "ops-team" = "admin"
  }
  protected_branches          = ["main"]
  topics                      = ["terraform", "public", "example"]
  homepage                    = "https://example.com"
  delete_head_on_merge        = true
  allow_auto_merge            = true
  dependabot_security_updates = true
  advance_security            = true
  action_secrets = {
    "SECRET_KEY" = "encrypted_value"
  }
  codespace_secrets = {
    "DATABASE_URL" = "encrypted_value"
  }
  dependabot_secrets = {
    "NPM_TOKEN" = "encrypted_value"
  }
  environments = {
    "production" = {
      action_secrets = {
        "AWS_ACCESS_KEY_ID"     = "encrypted_value",
        "AWS_SECRET_ACCESS_KEY" = "encrypted_value"
      }
    }
  }
  template_repository = {
    owner                = "example-org",
    repository           = "template-repo",
    include_all_branches = false
  }
  license_template = "mit"
}
