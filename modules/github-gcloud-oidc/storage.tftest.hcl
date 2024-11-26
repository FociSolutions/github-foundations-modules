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
  storage_class               = "REGIONAL"
  force_destroy               = true
  uniform_bucket_level_access = false
  labels                      = { label1 = "value1", label2 = "value2" }
  default_event_based_hold    = true
  requester_pays              = true
  versioning                  = true
}

run "expect_parent_errors_test" {
  variables {
    parent = "invalid-parent"
  }
  command = plan

  expect_failures = [var.parent]
}

run "expect_prefix_errors_test" {
  variables {
    prefix = ""
  }

  command = plan

  expect_failures = [var.prefix]
}

run "expect_project_parent_errors_test" {
  variables {
    project_parent = "invalid-parent"
  }
  command = plan

  expect_failures = [var.project_parent]
}

run "expect_storage_class_errors_test" {
  variables {
    storage_class = "INVALID"
  }
  command = plan

  expect_failures = [var.storage_class]
}

run "expect_lifecycle_rules_action_type_errors_test" {
  variables {
    lifecycle_rules = {
      rule1 = {
        action = {
          type = "INVALID"
        }
        condition = {
          age = 30
        }
      }
    }
  }
  command = plan

  expect_failures = [var.lifecycle_rules]
}

run "expect_lifecycle_rules_storage_class_errors_test" {
  variables {
    lifecycle_rules = {
      rule1 = {
        action = {
          type = "SetStorageClass"
        }
        condition = {
          age = 30
        }
      }
    }
  }
  command = plan

  expect_failures = [var.lifecycle_rules]
}

run "storage_bucket_test" {

  # Set some extra variables for this test
  variables {
    autoclass = true
    website = {
      main_page_suffix = "index.html"
      not_found_page   = "404.html"
    }
    encryption_key = "projects/${var.project_name}/locations/${var.location}/keyRings/${var.bucket_name}-keyring/cryptoKeys/${var.bucket_name}-key"
    retention_policy = {
      retention_period = 30
      is_locked        = true
    }
    logging_config = {
      log_bucket        = "log-bucket"
      log_object_prefix = "log-object-prefix"
    }
    cors = {
      origin          = ["*"]
      method          = ["GET", "POST"]
      response_header = ["Content-Type"]
      max_age_seconds = 3600
    }
    lifecycle_rules = {
      rule1 = {
        action = {
          type          = "Delete"
          storage_class = "NEARLINE"
        }
        condition = {
          age = 30
        }
      }
    }
    custom_placement_config = ["us-central1", "us-west1"]
  }

  command = apply

  assert {
    condition     = google_storage_bucket.bucket.name == var.bucket_name
    error_message = "The bucket name is incorrect. Expected ${var.bucket_name} but got ${google_storage_bucket.bucket.name}."
  }
  assert {
    condition     = startswith(google_storage_bucket.bucket.project, var.project_name)
    error_message = "The project name is incorrect. Expected ${var.project_name}#### but got ${google_storage_bucket.bucket.project}."
  }
  assert {
    condition     = google_storage_bucket.bucket.location == var.location
    error_message = "The location is incorrect. Expected ${var.location} but got ${google_storage_bucket.bucket.location}."
  }
  assert {
    condition     = google_storage_bucket.bucket.storage_class == var.storage_class
    error_message = "The storage class is incorrect. Expected ${var.storage_class} but got ${google_storage_bucket.bucket.storage_class}."
  }
  assert {
    condition     = google_storage_bucket.bucket.force_destroy == var.force_destroy
    error_message = "The force destroy is incorrect. Expected ${var.force_destroy} but got ${google_storage_bucket.bucket.force_destroy}."
  }
  assert {
    condition     = google_storage_bucket.bucket.uniform_bucket_level_access == var.uniform_bucket_level_access
    error_message = "The uniform bucket level access is incorrect. Expected ${var.uniform_bucket_level_access} but got ${google_storage_bucket.bucket.uniform_bucket_level_access}."
  }
  assert {
    condition     = google_storage_bucket.bucket.labels.label1 == var.labels.label1
    error_message = "The label1 is incorrect. Expected ${var.labels.label1} but got ${google_storage_bucket.bucket.labels.label1}."
  }
  assert {
    condition     = google_storage_bucket.bucket.labels.label2 == var.labels.label2
    error_message = "The label2 is incorrect. Expected ${var.labels.label2} but got ${google_storage_bucket.bucket.labels.label2}."
  }
  assert {
    condition     = google_storage_bucket.bucket.default_event_based_hold == var.default_event_based_hold
    error_message = "The default event based hold is incorrect. Expected ${var.default_event_based_hold} but got ${google_storage_bucket.bucket.default_event_based_hold}."
  }
  assert {
    condition     = google_storage_bucket.bucket.requester_pays == var.requester_pays
    error_message = "The requester pays is incorrect. Expected ${var.requester_pays} but got ${google_storage_bucket.bucket.requester_pays}."
  }
}
