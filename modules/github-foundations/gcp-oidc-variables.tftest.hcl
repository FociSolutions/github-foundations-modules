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
}

run "organization_workload_identity_sa_test" {

  command = apply

  assert {
    condition     = github_actions_secret.organization_workload_identity_sa[0].repository == "organizations"
    error_message = "The repository of the organization workload identity service account is incorrect. Expected 'organizations' but got '${github_actions_secret.organization_workload_identity_sa[0].repository}'."
  }
  assert {
    condition     = github_actions_secret.organization_workload_identity_sa[0].secret_name == var.oidc_configuration.gcp.organization_workload_identity_sa_secret_name
    error_message = "The secret_name of the organization workload identity service account is incorrect. Expected '${var.oidc_configuration.gcp.organization_workload_identity_sa_secret_name}' but got '${github_actions_secret.organization_workload_identity_sa[0].secret_name}'."
  }
  assert {
    condition     = github_actions_secret.organization_workload_identity_sa[0].plaintext_value == var.oidc_configuration.gcp.organization_workload_identity_sa
    error_message = "The plaintext_value of the organization workload identity service account is incorrect. Expected '${var.oidc_configuration.gcp.organization_workload_identity_sa}' but got '${nonsensitive(github_actions_secret.organization_workload_identity_sa[0].plaintext_value)}'."
  }
}

run "gcp_secret_manager_project_id_test" {
  assert {
    condition     = github_actions_variable.gcp_secret_manager_project_id[0].repository == "organizations"
    error_message = "The repository of the GCP Secret Manager project ID is incorrect. Expected 'organizations' but got '${github_actions_variable.gcp_secret_manager_project_id[0].repository}'."
  }
  assert {
    condition     = github_actions_variable.gcp_secret_manager_project_id[0].variable_name == var.oidc_configuration.gcp.gcp_secret_manager_project_id_variable_name
    error_message = "The variable_name of the GCP Secret Manager project ID is incorrect. Expected '${var.oidc_configuration.gcp.gcp_secret_manager_project_id_variable_name}' but got '${github_actions_variable.gcp_secret_manager_project_id[0].variable_name}'."
  }
  assert {
    condition     = github_actions_variable.gcp_secret_manager_project_id[0].value == var.oidc_configuration.gcp.gcp_secret_manager_project_id
    error_message = "The value of the GCP Secret Manager project ID is incorrect. Expected '${var.oidc_configuration.gcp.gcp_secret_manager_project_id}' but got '${github_actions_variable.gcp_secret_manager_project_id[0].value}'."
  }
}

run "workload_identity_provider_test" {
  assert {
    condition     = github_actions_organization_secret.workload_identity_provider[0].secret_name == var.oidc_configuration.gcp.workload_identity_provider_name_secret_name
    error_message = "The secret_name of the workload identity provider is incorrect. Expected '${var.oidc_configuration.gcp.workload_identity_provider_name_secret_name}' but got '${github_actions_organization_secret.workload_identity_provider[0].secret_name}'."
  }
  assert {
    condition     = github_actions_organization_secret.workload_identity_provider[0].plaintext_value == var.oidc_configuration.gcp.workload_identity_provider_name
    error_message = "The plaintext_value of the workload identity provider is incorrect. Expected '${var.oidc_configuration.gcp.workload_identity_provider_name}' but got '${nonsensitive(github_actions_organization_secret.workload_identity_provider[0].plaintext_value)}'."
  }
}

run "tf_state_bucket_project_id_test" {
  assert {
    condition     = github_actions_organization_variable.tf_state_bucket_project_id[0].variable_name == var.oidc_configuration.gcp.gcp_tf_state_bucket_project_id_variable_name
    error_message = "The variable_name of the TF state bucket project ID is incorrect. Expected '${var.oidc_configuration.gcp.gcp_tf_state_bucket_project_id_variable_name}' but got '${github_actions_organization_variable.tf_state_bucket_project_id[0].variable_name}'."
  }
  assert {
    condition     = github_actions_organization_variable.tf_state_bucket_project_id[0].value == var.oidc_configuration.gcp.gcp_tf_state_bucket_project_id
    error_message = "The value of the TF state bucket project ID is incorrect. Expected '${var.oidc_configuration.gcp.gcp_tf_state_bucket_project_id}' but got '${github_actions_organization_variable.tf_state_bucket_project_id[0].value}'."
  }
}

run "tf_state_bucket_name_test" {
  assert {
    condition     = github_actions_organization_variable.tf_state_bucket_name[0].variable_name == var.oidc_configuration.gcp.bucket_name_variable_name
    error_message = "The variable_name of the TF state bucket name is incorrect. Expected '${var.oidc_configuration.gcp.bucket_name_variable_name}' but got '${github_actions_organization_variable.tf_state_bucket_name[0].variable_name}'."
  }
  assert {
    condition     = github_actions_organization_variable.tf_state_bucket_name[0].value == var.oidc_configuration.gcp.bucket_name
    error_message = "The value of the TF state bucket name is incorrect. Expected '${var.oidc_configuration.gcp.bucket_name}' but got '${github_actions_organization_variable.tf_state_bucket_name[0].value}'."
  }
}

run "tf_state_bucket_location_test" {
  assert {
    condition     = github_actions_organization_variable.tf_state_bucket_location[0].variable_name == var.oidc_configuration.gcp.bucket_location_variable_name
    error_message = "The variable_name of the TF state bucket location is incorrect. Expected '${var.oidc_configuration.gcp.bucket_location_variable_name}' but got '${github_actions_organization_variable.tf_state_bucket_location[0].variable_name}'."
  }
  assert {
    condition     = github_actions_organization_variable.tf_state_bucket_location[0].value == var.oidc_configuration.gcp.bucket_location
    error_message = "The value of the TF state bucket location is incorrect. Expected '${var.oidc_configuration.gcp.bucket_location}' but got '${github_actions_organization_variable.tf_state_bucket_location[0].value}'."
  }
  assert {
    condition     = github_actions_organization_variable.tf_state_bucket_location[0].visibility == "selected"
    error_message = "The visibility of the TF state bucket location is incorrect. Expected 'selected' but got '${github_actions_organization_variable.tf_state_bucket_location[0].visibility}'."
  }
}
