mock_provider "github" {}

variables {
  # required variables
  account_type = "Enterprise"
  oidc_configuration = {
    gcp = {
      workload_identity_provider_name_secret_name = "workload_identity_provider_name_secret_name"
      workload_identity_provider_name             = "workload_identity_provider_name"

      organization_workload_identity_sa_secret_name = "organization_workload_identity_sa_secret_name"
      organization_workload_identity_sa             = "organization_workload_identity_sa"

      gcp_secret_manager_project_id_variable_name = "gcp_secret_manager_project_id_variable_name"
      gcp_secret_manager_project_id               = "gcp_secret_manager_project_id"

      gcp_tf_state_bucket_project_id_variable_name = "gcp_tf_state_bucket_project_id_variable_name"
      gcp_tf_state_bucket_project_id               = "gcp_tf_state_bucket_project_id"

      bucket_name_variable_name = "bucket_name_variable_name"
      bucket_name               = "bucket_name"

      bucket_location_variable_name = "bucket_location_variable_name"
      bucket_location               = "bucket_location"
    }
  }
}

run "base_ruleset_module_test" {
  command = apply

  assert {
    condition     = length(module.base_ruleset) == 1
    error_message = "The base ruleset module was not created."
  }
}
