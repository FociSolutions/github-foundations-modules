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

  # variables for this test
  folder_create = true
}

run "folder_test" {
  command = apply

  assert {
    condition     = google_folder.folder[0].display_name == var.folder_name
    error_message = "The folder name is incorrect. Expected ${var.folder_name} but got ${google_folder.folder[0].display_name}."
  }
  assert {
    condition     = google_folder.folder[0].parent == var.parent
    error_message = "The folder parent is incorrect. Expected ${var.parent} but got ${google_folder.folder[0].parent}."
  }

}
