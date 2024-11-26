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
  project_create      = true
  billing_account     = "billing-account"
  auto_create_network = true
  labels              = { label1 = "value1", label2 = "value2" }
  services            = ["service1.googleapis.com", "service2.googleapis.com"]
  service_config = {
    disable_on_destroy         = true
    disable_dependent_services = true
  }
}


# run "expect_project_errors_test" {
#     variables {
#         services                    = ["service1", "service2"]
#     }
#     command = apply
#     plan_options {
#         refresh = true
#     }

#     expect_failures = [ google_project.project, google_project_service.project_services ]
# }

run "google_project_test" {
  command = apply

  assert {
    condition     = length(google_project.project) == 1
    error_message = "The project was not created."
  }
  assert {
    condition     = google_project.project[0].org_id == split("/", var.project_parent)[1]
    error_message = "The org_id is incorrect. Expected ${split("/", var.project_parent)[1]} but got ${google_project.project[0].org_id}."
  }
  assert {
    condition     = google_project.project[0].folder_id == null
    error_message = "The folder_id is incorrect. Expected null."
  }
  assert {
    condition     = startswith(google_project.project[0].project_id, var.project_name)
    error_message = "The project name is incorrect. Expected '${var.project_name}####' but got '${google_project.project[0].project_id}'."
  }
  assert {
    condition     = startswith(google_project.project[0].name, var.project_name)
    error_message = "The project name is incorrect. Expected '${var.project_name}####' but got '${google_project.project[0].name}'."
  }
  assert {
    condition     = google_project.project[0].billing_account == var.billing_account
    error_message = "The billing account is incorrect. Expected '${var.billing_account}' but got '${google_project.project[0].billing_account}'."
  }
  assert {
    condition     = google_project.project[0].auto_create_network == var.auto_create_network
    error_message = "The auto_create_network is incorrect. Expected '${var.auto_create_network}' but got '${google_project.project[0].auto_create_network}'."
  }
  assert {
    condition     = google_project.project[0].labels.label1 == var.labels.label1
    error_message = "The label1 is incorrect. Expected '${var.labels.label1}' but got '${google_project.project[0].labels.label1}'."
  }
  assert {
    condition     = google_project.project[0].labels.label2 == var.labels.label2
    error_message = "The label2 is incorrect. Expected '${var.labels.label2}' but got '${google_project.project[0].labels.label2}'."
  }
}

run "project_services_test" {
  assert {
    condition     = length(google_project_service.project_services) == length(var.services)
    error_message = "The number of services is incorrect. Expected ${length(var.services)} but got ${length(google_project_service.project_services)}."
  }
  # test the first service
  assert {
    condition     = google_project_service.project_services["service1.googleapis.com"].project == google_project.project[0].project_id
    error_message = "The service1 project is incorrect. Expected '${google_project.project[0].project_id}' but got '${google_project_service.project_services["service1.googleapis.com"].project}'."
  }
  assert {
    condition     = google_project_service.project_services["service1.googleapis.com"] != null
    error_message = "The service1 was not created."
  }
  assert {
    condition     = google_project_service.project_services["service1.googleapis.com"].service == "service1.googleapis.com"
    error_message = "The service1 name is incorrect. Expected 'service1.googleapis.com' but got '${google_project_service.project_services["service1.googleapis.com"].service}'."
  }
  assert {
    condition     = google_project_service.project_services["service1.googleapis.com"].disable_on_destroy == var.service_config.disable_on_destroy
    error_message = "The service1 disable_on_destroy is incorrect. Expected '${var.service_config.disable_on_destroy}' but got '${google_project_service.project_services["service1.googleapis.com"].disable_on_destroy}'."
  }
  assert {
    condition     = google_project_service.project_services["service1.googleapis.com"].disable_dependent_services == var.service_config.disable_dependent_services
    error_message = "The service1 disable_dependent_services is incorrect. Expected '${var.service_config.disable_dependent_services}' but got '${google_project_service.project_services["service1.googleapis.com"].disable_dependent_services}'."
  }
  # test the second service
  assert {
    condition     = google_project_service.project_services["service2.googleapis.com"].project == google_project.project[0].project_id
    error_message = "The service2 project is incorrect. Expected '${google_project.project[0].project_id}' but got '${google_project_service.project_services["service2.googleapis.com"].project}'."
  }
  assert {
    condition     = google_project_service.project_services["service2.googleapis.com"] != null
    error_message = "The service2 was not created."
  }
  assert {
    condition     = google_project_service.project_services["service2.googleapis.com"].service == "service2.googleapis.com"
    error_message = "The service2 name is incorrect. Expected 'service2.googleapis.com' but got '${google_project_service.project_services["service2.googleapis.com"].service}'."
  }
  assert {
    condition     = google_project_service.project_services["service2.googleapis.com"].disable_on_destroy == var.service_config.disable_on_destroy
    error_message = "The service2 disable_on_destroy is incorrect. Expected '${var.service_config.disable_on_destroy}' but got '${google_project_service.project_services["service2.googleapis.com"].disable_on_destroy}'."
  }
  assert {
    condition     = google_project_service.project_services["service2.googleapis.com"].disable_dependent_services == var.service_config.disable_dependent_services
    error_message = "The service2 disable_dependent_services is incorrect. Expected '${var.service_config.disable_dependent_services}' but got '${google_project_service.project_services["service2.googleapis.com"].disable_dependent_services}'."
  }
}
