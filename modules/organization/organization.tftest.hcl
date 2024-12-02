mock_provider "github" {}

variables {
  # required variables
  github_organization_billing_email = "org_billing_email@focisolutions.com"

  custom_repository_roles = {
    custom_role1 = {
      description = "Custom role 1"
      base_role   = "read"
      permissions = ["pull", "push"]
    }
    custom_role2 = {
      description = "Custom role 2"
      base_role   = "write"
      permissions = ["pull", "push", "delete"]
    }
  }

  # variables for this test
  enable_security_engineer_role = true
  enable_contractor_role        = false
  enable_community_manager_role = true

  github_organization_enable_ghas = false
}

run "custom_repository_role_test" {

  command = apply

  assert {
    condition     = length(output.custom_role_ids) == length(var.custom_repository_roles)
    error_message = "The number or roles is incorrect. Expected ${length(var.custom_repository_roles)} but got ${length(output.custom_role_ids)}."
  }
}
