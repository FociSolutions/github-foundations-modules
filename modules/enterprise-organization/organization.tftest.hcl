mock_provider "github" {}

variables {
  # required variables
  enterprise_id = "1234567890"
  name          = "github-foundations"
  display_name  = "GitHub Foundations"
  description   = "GitHub Foundations Organization"
  billing_email = "billingemail@focisolutions.com"
  admin_logins  = ["admin1", "admin2"]
}

run "organization_test" {
  command = apply

  assert {
    condition     = github_enterprise_organization.organization.id != null
    error_message = "The organization was not created."
  }
  assert {
    condition     = github_enterprise_organization.organization.enterprise_id == var.enterprise_id
    error_message = "The organization id is incorrect. Expected ${var.enterprise_id} but got ${github_enterprise_organization.organization.enterprise_id}."
  }
  assert {
    condition     = github_enterprise_organization.organization.name == var.name
    error_message = "The organization name is incorrect. Expected ${var.name} but got ${github_enterprise_organization.organization.name}."
  }
  assert {
    condition     = github_enterprise_organization.organization.display_name == var.display_name
    error_message = "The organization display name is incorrect. Expected ${var.display_name} but got ${github_enterprise_organization.organization.display_name}."
  }
  assert {
    condition     = github_enterprise_organization.organization.description == var.description
    error_message = "The organization description is incorrect. Expected ${var.description} but got ${github_enterprise_organization.organization.description}."
  }
  assert {
    condition     = github_enterprise_organization.organization.billing_email == var.billing_email
    error_message = "The organization billing email is incorrect. Expected ${var.billing_email} but got ${github_enterprise_organization.organization.billing_email}."
  }
  assert {
    condition     = length(github_enterprise_organization.organization.admin_logins) == length(var.admin_logins)
    error_message = "The organization admin logins are incorrect. Expected ${length(var.admin_logins)} but got ${length(github_enterprise_organization.organization.admin_logins)}."
  }
}
