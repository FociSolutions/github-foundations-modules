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
  readme_path = "../../README.md"
}

run "repo_readme_test" {

  command = apply

  assert {
    condition     = github_repository_file.main_readme[0].repository == "organizations"
    error_message = "The repository of the main readme file is incorrect. Expected 'organizations' but got '${github_repository_file.main_readme[0].repository}'."
  }
  assert {
    condition     = github_repository_file.main_readme[0].file == "README.md"
    error_message = "The file of the main readme file is incorrect. Expected 'README.md' but got '${github_repository_file.main_readme[0].file}'."
  }
  assert {
    condition     = startswith(github_repository_file.main_readme[0].content, "# github-foundations-modules\n")
    error_message = "The content of the main readme file is incorrect."
  }
}
