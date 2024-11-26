mock_provider "github" {}

variables {
  # required variables
  account_type = "Organization"
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

  # Variables for this test
  foundation_devs_team_name = "foundation-devs"
}

run "create_gcp_teams_test" {

  command = apply

  assert {
    condition     = github_team.foundation_devs.name == var.foundation_devs_team_name
    error_message = "The name of the foundation developers team is incorrect. Expected '${var.foundation_devs_team_name}' but got '${github_team.foundation_devs.name}'."
  }
}
