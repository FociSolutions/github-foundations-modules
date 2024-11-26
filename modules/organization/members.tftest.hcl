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
  github_organization_members = ["user1", "user2", "user3", "user4", "user5"]
}

run "members_test" {

  command = apply

  assert {
    condition     = length(github_membership.membership_for_user) == length(var.github_organization_members)
    error_message = "The number or members is incorrect. Expected ${length(var.github_organization_members)} but got ${length(github_membership.membership_for_user)}."
  }
}
