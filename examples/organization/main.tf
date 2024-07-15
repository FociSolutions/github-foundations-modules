module "organization" {
  source = "../../modules/organization"

  github_organization_billing_email = "org-billing@focisolutions.com"
  github_organization_email         = "info@focisolutions.com"
  github_organization_blog          = "https://www.focisolutions.com/articles/"
  github_organization_location      = "Ottawa"

  github_organization_blocked_users                          = []
  github_organization_enable_ghas                            = false
  github_organization_enable_dependabot_alerts               = true
  github_organization_enable_dependabot_updates              = true
  github_organization_enable_dependancy_graph                = true
  github_organization_enable_secret_scanning                 = true
  github_organization_enable_secret_scanning_push_protection = true
  github_organization_requires_web_commit_signing            = true
  github_organization_repository_settings = {
    members_can_create_public   = true,
    members_can_create_internal = true,
    members_can_create_private  = true
  }

  github_organization_members = ["blastdan"]

  custom_repository_roles = {}
}
