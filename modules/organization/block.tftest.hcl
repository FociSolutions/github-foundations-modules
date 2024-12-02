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
  github_organization_blocked_users = ["user1", "user2", "user3", "user4"]
}

run "blocked_user_test" {

  command = apply

  assert {
    condition     = length(github_organization_block.blocked_user) == length(var.github_organization_blocked_users)
    error_message = "The number or blocked users is incorrect. Expected ${length(var.github_organization_blocked_users)} but got ${length(github_organization_block.blocked_user)}."
  }
}
