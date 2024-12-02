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

    custom = {
      organization_secrets = {
        secret1 = "c2VjcmV0MQ==", # "secret1" base64 encoded
        secret2 = "c2VjcmV0Mg=="  # "secret2" base64
      }
      organization_variables = {
        variable1 = "variable1"
        variable2 = "variable2"
      }
      repository_secrets = {
        repo1 = {
          secret1 = "c2VjcmV0MQ==", # "secret1" base64 encoded
          secret2 = "c2VjcmV0Mg=="  # "secret2" base64
        },
        repo2 = {
          secret1 = "c2VjcmV0MQ==", # "secret1" base64 encoded
          secret2 = "c2VjcmV0Mg=="  # "secret2" base64
        }
      }
      repository_variables = {
        repo1 = {
          variable1 = "variable1",
          variable2 = "variable2"
        },
        repo2 = {
          variable1 = "variable1",
          variable2 = "variable2"
        }
      }
    }
  }
}

run "custom_oidc_organization_secret_test" {
  command = apply

  assert {
    condition     = length(github_actions_organization_secret.custom_oidc_organization_secret) == 2
    error_message = "The number of organization secrets is incorrect. Expected 2 but got ${length(github_actions_organization_secret.custom_oidc_organization_secret)}."
  }
}

run "custom_oidc_organization_variable_test" {
  assert {
    condition     = length(github_actions_organization_variable.custom_oidc_organization_variable) == 2
    error_message = "The number of organization variables is incorrect. Expected 2 but got ${length(github_actions_organization_variable.custom_oidc_organization_variable)}."
  }
}

run "repository_secret_test" {
  assert {
    condition     = length(github_actions_secret.repository_secret) == 4
    error_message = "The number of repository secrets is incorrect. Expected 4 but got ${length(github_actions_secret.repository_secret)}."
  }
  assert {
    condition     = github_actions_secret.repository_secret["repo1_secret1"].encrypted_value == var.oidc_configuration.custom.repository_secrets.repo1.secret1
    error_message = "Repository secret repo1_secret1 is incorrect. Expected '${var.oidc_configuration.custom.repository_secrets.repo1.secret1}' but got ${nonsensitive(github_actions_secret.repository_secret["repo1_secret1"].encrypted_value)}."
  }
  assert {
    condition     = github_actions_secret.repository_secret["repo1_secret2"].encrypted_value == var.oidc_configuration.custom.repository_secrets.repo1.secret2
    error_message = "Repository secret repo1_secret2 is incorrect. Expected '${var.oidc_configuration.custom.repository_secrets.repo1.secret2}' but got ${nonsensitive(github_actions_secret.repository_secret["repo1_secret2"].encrypted_value)}."
  }
  assert {
    condition     = github_actions_secret.repository_secret["repo2_secret1"].encrypted_value == var.oidc_configuration.custom.repository_secrets.repo2.secret1
    error_message = "Repository secret repo2_secret1 is incorrect. Expected '${var.oidc_configuration.custom.repository_secrets.repo2.secret1}' but got ${nonsensitive(github_actions_secret.repository_secret["repo2_secret1"].encrypted_value)}."
  }
  assert {
    condition     = github_actions_secret.repository_secret["repo2_secret2"].encrypted_value == var.oidc_configuration.custom.repository_secrets.repo2.secret2
    error_message = "Repository secret repo2_secret2 is incorrect. Expected '${var.oidc_configuration.custom.repository_secrets.repo2.secret2}' but got ${nonsensitive(github_actions_secret.repository_secret["repo2_secret2"].encrypted_value)}."
  }
}

run "repository_variable_test" {
  assert {
    condition     = length(github_actions_variable.repository_variable) == 4
    error_message = "The number of repository variables is incorrect. Expected 4 but got ${length(github_actions_variable.repository_variable)}."
  }
  assert {
    condition     = github_actions_variable.repository_variable["repo1_variable1"].value == var.oidc_configuration.custom.repository_variables.repo1.variable1
    error_message = "Repository variable repo1_variable1 is incorrect. Expected '${var.oidc_configuration.custom.repository_variables.repo1.variable1}' but got ${github_actions_variable.repository_variable["repo1_variable1"].value}."
  }
  assert {
    condition     = github_actions_variable.repository_variable["repo1_variable2"].value == var.oidc_configuration.custom.repository_variables.repo1.variable2
    error_message = "Repository variable repo1_variable2 is incorrect. Expected '${var.oidc_configuration.custom.repository_variables.repo1.variable2}' but got ${github_actions_variable.repository_variable["repo1_variable2"].value}."
  }
  assert {
    condition     = github_actions_variable.repository_variable["repo2_variable1"].value == var.oidc_configuration.custom.repository_variables.repo2.variable1
    error_message = "Repository variable repo2_variable1 is incorrect. Expected '${var.oidc_configuration.custom.repository_variables.repo2.variable1}' but got ${github_actions_variable.repository_variable["repo2_variable1"].value}."
  }
  assert {
    condition     = github_actions_variable.repository_variable["repo2_variable2"].value == var.oidc_configuration.custom.repository_variables.repo2.variable2
    error_message = "Repository variable repo2_variable2 is incorrect. Expected '${var.oidc_configuration.custom.repository_variables.repo2.variable2}' but got ${github_actions_variable.repository_variable["repo2_variable2"].value}."
  }
}
