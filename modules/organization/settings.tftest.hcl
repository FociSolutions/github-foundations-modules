mock_provider "github" {}

variables {
  github_organization_billing_email               = "org_billing_email@focisolutions.com"
  github_organization_email                       = "org_email@focisolutions.com"
  github_organization_blog                        = "org_blog"
  github_organization_location                    = "org_location"
  github_organization_requires_web_commit_signing = false

  github_organization_enable_ghas                            = true
  github_organization_enable_dependabot_alerts               = true
  github_organization_enable_dependabot_updates              = true
  github_organization_enable_dependancy_graph                = true
  github_organization_enable_secret_scanning                 = true
  github_organization_enable_secret_scanning_push_protection = true

  github_organization_pages_settings = {
    members_can_create_public  = true
    members_can_create_private = true
  }

  github_organization_repository_settings = {
    members_can_create_public   = true
    members_can_create_internal = true
    members_can_create_private  = true
  }

  custom_repository_roles = {
    custom_role1 = {
      description = "Custom role 1"
      base_role   = "read"
      permissions = ["pull", "push"]
    }
  }
}

run "organization_settings_test" {
  command = apply

  assert {
    condition     = github_organization_settings.organization_settings.billing_email == var.github_organization_billing_email
    error_message = "The billing email is not set correctly. Expected: ${var.github_organization_billing_email}, got: ${github_organization_settings.organization_settings.billing_email}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.email == var.github_organization_email
    error_message = "The email is not set correctly. Expected: ${var.github_organization_email}, got: ${github_organization_settings.organization_settings.email}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.blog == var.github_organization_blog
    error_message = "The blog is not set correctly. Expected: ${var.github_organization_blog}, got: ${github_organization_settings.organization_settings.blog}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.location == var.github_organization_location
    error_message = "The location is not set correctly. Expected: ${var.github_organization_location}, got: ${github_organization_settings.organization_settings.location}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.web_commit_signoff_required == var.github_organization_requires_web_commit_signing
    error_message = "The web commit signoff required is not set correctly. Expected: ${var.github_organization_requires_web_commit_signing}, got: ${github_organization_settings.organization_settings.web_commit_signoff_required}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.has_organization_projects == true
    error_message = "The organization projects are not enabled. Expected: true, got: ${github_organization_settings.organization_settings.has_organization_projects}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.has_repository_projects == true
    error_message = "The repository projects are not enabled. Expected: true, got: ${github_organization_settings.organization_settings.has_repository_projects}"
  }

  # Github advance security, dependabot, and secret scanning
  assert {
    condition     = github_organization_settings.organization_settings.advanced_security_enabled_for_new_repositories == var.github_organization_enable_ghas
    error_message = "The advance security is not set correctly. Expected: ${var.github_organization_enable_ghas}, got: ${github_organization_settings.organization_settings.advanced_security_enabled_for_new_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.dependabot_alerts_enabled_for_new_repositories == var.github_organization_enable_dependabot_alerts
    error_message = "The dependabot alerts are not enabled. Expected: ${var.github_organization_enable_dependabot_alerts}, got: ${github_organization_settings.organization_settings.dependabot_alerts_enabled_for_new_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.dependabot_security_updates_enabled_for_new_repositories == var.github_organization_enable_dependabot_updates
    error_message = "The dependabot security updates are not enabled. Expected: ${var.github_organization_enable_dependabot_updates}, got: ${github_organization_settings.organization_settings.dependabot_security_updates_enabled_for_new_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.dependency_graph_enabled_for_new_repositories == var.github_organization_enable_dependancy_graph
    error_message = "The dependency graph is not enabled. Expected: ${var.github_organization_enable_dependancy_graph}, got: ${github_organization_settings.organization_settings.dependency_graph_enabled_for_new_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.secret_scanning_enabled_for_new_repositories == var.github_organization_enable_secret_scanning
    error_message = "The secret scanning is not enabled. Expected: ${var.github_organization_enable_secret_scanning}, got: ${github_organization_settings.organization_settings.secret_scanning_enabled_for_new_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.secret_scanning_push_protection_enabled_for_new_repositories == var.github_organization_enable_secret_scanning_push_protection
    error_message = "The secret scanning push protection is not enabled. Expected: ${var.github_organization_enable_secret_scanning_push_protection}, got: ${github_organization_settings.organization_settings.secret_scanning_push_protection_enabled_for_new_repositories}"
  }

  #Organization pages
  assert {
    condition     = github_organization_settings.organization_settings.members_can_create_pages == true
    error_message = "The members can create pages is not enabled. Expected: true, got: ${github_organization_settings.organization_settings.members_can_create_pages}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.members_can_create_public_pages == var.github_organization_pages_settings.members_can_create_public
    error_message = "The members can create public pages is not enabled. Expected: ${var.github_organization_pages_settings.members_can_create_public}, got: ${github_organization_settings.organization_settings.members_can_create_public_pages}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.members_can_create_private_pages == var.github_organization_pages_settings.members_can_create_private
    error_message = "The members can create private pages is not enabled. Expected: ${var.github_organization_pages_settings.members_can_create_private}, got: ${github_organization_settings.organization_settings.members_can_create_private_pages}"
  }

  #Organization Repository settings
  assert {
    condition     = github_organization_settings.organization_settings.members_can_create_repositories == true
    error_message = "The members can create repositories is not enabled. Expected: true, got: ${github_organization_settings.organization_settings.members_can_create_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.members_can_create_public_repositories == var.github_organization_repository_settings.members_can_create_public
    error_message = "The members can create public repositories is not enabled. Expected: ${var.github_organization_repository_settings.members_can_create_public}, got: ${github_organization_settings.organization_settings.members_can_create_public_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.members_can_create_internal_repositories == var.github_organization_repository_settings.members_can_create_internal
    error_message = "The members can create internal repositories is not enabled. Expected: ${var.github_organization_repository_settings.members_can_create_internal}, got: ${github_organization_settings.organization_settings.members_can_create_internal_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.members_can_create_private_repositories == var.github_organization_repository_settings.members_can_create_private
    error_message = "The members can create private repositories is not enabled. Expected: ${var.github_organization_repository_settings.members_can_create_private}, got: ${github_organization_settings.organization_settings.members_can_create_private_repositories}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.default_repository_permission == "none"
    error_message = "The default repository permission is not set correctly. Expected: none, got: ${github_organization_settings.organization_settings.default_repository_permission}"
  }
  assert {
    condition     = github_organization_settings.organization_settings.members_can_fork_private_repositories == false
    error_message = "The members can fork private repositories is not set correctly. Expected: false, got: ${github_organization_settings.organization_settings.members_can_fork_private_repositories}"
  }
}
