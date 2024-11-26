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
  enable_contractor_role        = true
  enable_community_manager_role = true
}

run "custom_repository_role_test" {

  command = apply

  assert {
    condition     = length(github_organization_custom_role.custom_repository_role) == length(var.custom_repository_roles)
    error_message = "The number or roles is incorrect. Expected ${length(var.custom_repository_roles)} but got ${length(github_organization_custom_role.custom_repository_role)}."
  }
}

run "custom_repository_role_failure_test" {

  # too many custom roles - expect failure
  variables {
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
      custom_role3 = {
        description = "Custom role 3"
        base_role   = "maintain"
        permissions = ["pull", "push", "delete", "admin"]
      }
    }
  }

  command         = plan
  expect_failures = [github_organization_custom_role.custom_repository_role]
}

run "security_engineer_role_test" {

  assert {
    condition     = github_organization_custom_role.security_engineer_role[0] != null
    error_message = "The security engineer role was not created."
  }
  assert {
    condition     = github_organization_custom_role.security_engineer_role[0].name == "Security Engineer"
    error_message = "The security engineer role name is incorrect. Expected 'Security Engineer' but got '${github_organization_custom_role.security_engineer_role[0].name}'."
  }
  assert {
    condition     = github_organization_custom_role.security_engineer_role[0].base_role == "maintain"
    error_message = "The security engineer role base role is incorrect. Expected 'maintain' but got '${github_organization_custom_role.security_engineer_role[0].base_role}'."
  }
  assert {
    condition     = length(github_organization_custom_role.security_engineer_role[0].permissions) == 2
    error_message = "The security engineer role permissions are incorrect. Expected 2 but got ${length(github_organization_custom_role.security_engineer_role[0].permissions)}."
  }
}

run "contractor_role_test" {

  assert {
    condition     = github_organization_custom_role.contractor_role[0] != null
    error_message = "The contractor role was not created."
  }
  assert {
    condition     = github_organization_custom_role.contractor_role[0].name == "Contractor"
    error_message = "The contractor role name is incorrect. Expected 'Contractor' but got '${github_organization_custom_role.contractor_role[0].name}'."
  }
  assert {
    condition     = github_organization_custom_role.contractor_role[0].base_role == "write"
    error_message = "The contractor role base role is incorrect. Expected 'write' but got '${github_organization_custom_role.contractor_role[0].base_role}'."
  }
  assert {
    condition     = length(github_organization_custom_role.contractor_role[0].permissions) == 1
    error_message = "The contractor role permissions are incorrect. Expected 1 but got ${length(github_organization_custom_role.contractor_role[0].permissions)}."
  }
}

run "community_manager_role_test" {

  assert {
    condition     = github_organization_custom_role.community_manager_role[0] != null
    error_message = "The community manager role was not created."
  }
  assert {
    condition     = github_organization_custom_role.community_manager_role[0].name == "Community Manager"
    error_message = "The community manager role name is incorrect. Expected 'Community Manager' but got '${github_organization_custom_role.community_manager_role[0].name}'."
  }
  assert {
    condition     = github_organization_custom_role.community_manager_role[0].base_role == "read"
    error_message = "The community manager role base role is incorrect. Expected 'read' but got '${github_organization_custom_role.community_manager_role[0].base_role}'."
  }
  assert {
    condition     = length(github_organization_custom_role.community_manager_role[0].permissions) == 13
    error_message = "The community manager role permissions are incorrect. Expected 13 but got ${length(github_organization_custom_role.community_manager_role[0].permissions)}."
  }
}
