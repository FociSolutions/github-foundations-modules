mock_provider "github" {}
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
  bootstrap_repo_name     = "bootstrap-repo"
  organizations_repo_name = "organizations-repo"
}


mock_provider "google" {
  override_resource {
    target = google_service_account.bootstrap_sa
    values = {
      name = "bootstrap-repo-sa"
    }
  }
  override_resource {
    target = google_service_account.organizations_sa
    values = {
      name = "organizations-repo-sa"
    }
  }
}

run "bootstrap_sa_test" {
  command = apply

  assert {
    condition     = google_service_account.bootstrap_sa.name == "${var.bootstrap_repo_name}-sa"
    error_message = "The bootstrap service account name is incorrect. Expected ${var.bootstrap_repo_name}-sa but got ${google_service_account.bootstrap_sa.name}."
  }
  assert {
    condition     = google_service_account.bootstrap_sa.account_id == "${var.bootstrap_repo_name}-sa"
    error_message = "The bootstrap service account account_id is incorrect. Expected ${var.bootstrap_repo_name} but got ${google_service_account.bootstrap_sa.account_id}."
  }
}

run "organizations_sa_test" {
  assert {
    condition     = google_service_account.organizations_sa.name == "${var.organizations_repo_name}-sa"
    error_message = "The organizations service account name is incorrect. Expected ${var.organizations_repo_name}-sa but got ${google_service_account.organizations_sa.name}."
  }
  assert {
    condition     = google_service_account.organizations_sa.account_id == "${var.organizations_repo_name}-sa"
    error_message = "The organizations service account account_id is incorrect. Expected ${var.organizations_repo_name} but got ${google_service_account.organizations_sa.account_id}."
  }
}
