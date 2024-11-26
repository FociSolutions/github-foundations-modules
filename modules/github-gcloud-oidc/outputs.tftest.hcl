mock_provider "github" {}
mock_provider "google" {}
mock_provider "google-beta" {}
mock_provider "github-actions-runners" {}
override_module {
  target = module.oidc
  outputs = {
    gh-oidc = {
      sa_name   = "test-sa"
      attribute = "attribute.repository/github-foundations/bootstrap"
    }
    provider_name = "gh-oidc-provider"
  }
}

variables {
  # required variables
  github_foundations_organization_name = "github-foundations"
  parent                               = "organizations/1234567890"
  project_parent                       = "organizations/1234567890"
  project_name                         = "test-project"
  folder_name                          = "test-folder"
  bucket_name                          = "test-bucket"
  location                             = "US"

}

run "outputs_test" {
  command = apply

  assert {
    condition     = output.folder != null
    error_message = "The folder was not created."
  }
  assert {
    condition     = output.id == output.folder.name
    error_message = "The folder id is incorrect. Expected ${output.folder.name} but got ${output.id}."
  }
  assert {
    condition     = startswith(output.project_id, var.project_name)
    error_message = "The project id is incorrect. Expected ${var.project_name}#### but got ${output.project_id}."
  }
  assert {
    condition     = output.name == var.folder_name
    error_message = "The folder name is incorrect. Expected ${var.folder_name} but got ${output.name}."
  }
  assert {
    condition     = output.provider_name == "gh-oidc-provider"
    error_message = "The provider name is incorrect. Expected gh-oidc-provider but got ${output.provider_name}."
  }
  assert {
    condition     = output.bootstrap_sa != null
    error_message = "The bootstrap service account was not created."
  }
  assert {
    condition     = output.bootstrap_sa_name != null
    error_message = "The bootstrap service account name was not created."
  }
  assert {
    condition     = output.organizations_sa != null
    error_message = "The organizations service account was not created."
  }
  assert {
    condition     = output.organizations_sa_name != null
    error_message = "The organizations service account name was not created."
  }
  assert {
    condition     = output.bucket_name == var.bucket_name
    error_message = "The bucket name is incorrect. Expected ${var.bucket_name} but got ${output.bucket_name}."
  }
  assert {
    condition     = output.bucket_location == var.location
    error_message = "The bucket location is incorrect. Expected ${var.location} but got ${output.bucket_location}."
  }
}
