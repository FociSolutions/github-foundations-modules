mock_provider "github" {}
mock_provider "aws" {}

variables {
  # required variables
  github_foundations_organization_name = "github-foundations-org"
  github_thumbprints                   = ["990F4193972F2BECF12DDEDA5237F9C952F20D9E"]
}

run "github_foundations_rg_test" {
  command = apply

  assert {
    condition     = aws_resourcegroups_group.github_foundations_rg.name == "GithubFoundationResources"
    error_message = "The name of the resource group is incorrect. Expected 'GithubFoundationResources' but got '${aws_resourcegroups_group.github_foundations_rg.name}'."
  }
  assert {
    condition     = aws_resourcegroups_group.github_foundations_rg.resource_query[0].query == "{\"ResourceTypeFilters\":[\"AWS::AllSupported\"],\"TagFilters\":[{\"Key\":\"Purpose\",\"Values\":[\"Github Foundations\"]}]}"
    error_message = "The resource query of the resource group is incorrect. Expected '{\"ResourceTypeFilters\":[\"AWS::AllSupported\"],\"TagFilters\":[{\"Key\":\"Purpose\",\"Values\":[\"Github Foundations\"]}]}' but got '${aws_resourcegroups_group.github_foundations_rg.resource_query[0].query}'."
  }
}

run "github_foundations_rg_test_rg_name" {
  variables {
    rg_name = "ghf-set-by-test-rg"
  }

  command = apply

  assert {
    condition     = aws_resourcegroups_group.github_foundations_rg.name == "ghf-set-by-test-rg"
    error_message = "The name of the resource group is incorrect. Expected 'ghf-set-by-test-rg' but got '${aws_resourcegroups_group.github_foundations_rg.name}'."
  }
}
