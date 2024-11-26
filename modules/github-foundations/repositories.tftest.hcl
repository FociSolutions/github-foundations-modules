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
  bootstrap_repository_name = "bootstrap-repo"
}

run "bootstrap_repo_test" {

  command = apply

  assert {
    condition     = github_repository.bootstrap_repo.name == var.bootstrap_repository_name
    error_message = "The name of the bootstrap repository is incorrect. Expected '${var.bootstrap_repository_name}' but got '${github_repository.bootstrap_repo.name}'."
  }
  assert {
    condition     = github_repository.bootstrap_repo.visibility == "private"
    error_message = "The visibility of the bootstrap repository is incorrect. Expected 'private' but got '${github_repository.bootstrap_repo.visibility}'."
  }
  assert {
    condition     = github_repository.bootstrap_repo.auto_init == true
    error_message = "The auto_init of the bootstrap repository is incorrect. Expected 'true' but got '${github_repository.bootstrap_repo.auto_init}'."
  }
  assert {
    condition     = github_repository.bootstrap_repo.delete_branch_on_merge == true
    error_message = "The delete_branch_on_merge of the bootstrap repository is incorrect. Expected 'true' but got '${github_repository.bootstrap_repo.delete_branch_on_merge}'."
  }
  assert {
    condition     = github_repository.bootstrap_repo.vulnerability_alerts == true
    error_message = "The vulnerability_alerts of the bootstrap repository is incorrect. Expected 'true' but got '${github_repository.bootstrap_repo.vulnerability_alerts}'."
  }
}

run "bootstrap_repo_collaborators_test" {
  assert {
    condition     = github_repository_collaborators.bootstrap_repo_collaborators.repository == github_repository.bootstrap_repo.name
    error_message = "The repository of the bootstrap repository collaborators is incorrect. Expected '${github_repository.bootstrap_repo.name}' but got '${github_repository_collaborators.bootstrap_repo_collaborators.repository}'."
  }
  assert {
    condition     = github_repository_collaborators.bootstrap_repo_collaborators.team != null
    error_message = "The permission of the bootstrap repository collaborators is incorrect. Got null."
  }
}

run "organizations_repo_test" {
  assert {
    condition     = github_repository.organizations_repo.name == var.organizations_repository_name
    error_message = "The name of the organizations repository is incorrect. Expected '${var.organizations_repository_name}' but got '${github_repository.organizations_repo.name}'."
  }
  assert {
    condition     = github_repository.organizations_repo.visibility == "private"
    error_message = "The visibility of the organizations repository is incorrect. Expected 'private' but got '${github_repository.organizations_repo.visibility}'."
  }
  assert {
    condition     = github_repository.organizations_repo.auto_init == true
    error_message = "The auto_init of the organizations repository is incorrect. Expected 'true' but got '${github_repository.organizations_repo.auto_init}'."
  }
  assert {
    condition     = github_repository.organizations_repo.delete_branch_on_merge == true
    error_message = "The delete_branch_on_merge of the organizations repository is incorrect. Expected 'true' but got '${github_repository.organizations_repo.delete_branch_on_merge}'."
  }
  assert {
    condition     = github_repository.organizations_repo.vulnerability_alerts == true
    error_message = "The vulnerability_alerts of the organizations repository is incorrect. Expected 'true' but got '${github_repository.organizations_repo.vulnerability_alerts}'."
  }
  assert {
    condition     = github_repository.organizations_repo.has_issues == true
    error_message = "The has_issues of the organizations repository is incorrect. Expected 'true' but got '${github_repository.organizations_repo.has_issues}'."
  }
}

run "organization_repo_collaborators_test" {
  assert {
    condition     = github_repository_collaborators.organization_repo_collaborators.repository == github_repository.organizations_repo.name
    error_message = "The repository of the organizations repository collaborators is incorrect. Expected '${github_repository.organizations_repo.name}' but got '${github_repository_collaborators.organization_repo_collaborators.repository}'."
  }
  assert {
    condition     = github_repository_collaborators.organization_repo_collaborators.team != null
    error_message = "The permission of the organizations repository collaborators is incorrect. Got null."
  }
}

run "drift_labels_test" {
  assert {
    condition     = length(github_issue_labels.drift_labels[0]) == 3
    error_message = "The number of drift labels is incorrect. Expected '3' but got '${length(github_issue_labels.drift_labels[0])}'."
  }
}
