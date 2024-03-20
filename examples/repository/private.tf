module "github_repository_example" {
  source = "../../modules/private_repository"

  name        = "example-repository"
  description = "This is an example repository created using Terraform."
  homepage    = "https://example.com"
  topics      = ["terraform", "automation", "github"]

  repository_team_permissions = {
    "devs" = "push",
    "ops"  = "admin"
  }

  default_branch       = "main"
  protected_branches   = ["main", "develop"]
  delete_head_on_merge = true
  allow_auto_merge     = true

  dependabot_security_updates = true
  advance_security            = true

  action_secrets = {
    "GH_TOKEN" = "*****"
  }

  codespace_secrets = {
    "CODESPACE_DB" = "*****"
  }

  dependabot_secrets = {
    "NPM_TOKEN" = "*****"
  }

  environments = {
    "staging" = {
      action_secrets = {
        "STAGE_API_KEY" = "*****"
      }
    }
  }

  template_repository = null
  license_template    = "mit"

  rulesets = {}
}
