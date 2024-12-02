mock_provider "github" {}

variables {
  # required variables
  account_type = "Organization"
  oidc_configuration = {
    aws = {
      s3_bucket_variable_name = "aws_s3_bucket_variable_name"
      s3_bucket               = "my-s3-bucket"

      region_variable_name = "aws_region_variable_name"
      region               = "us-west-2"

      organizations_role_variable_name = "aws_organizations_role_variable_name"
      organizations_role               = "my-organizations-role"

      dynamodb_table_variable_name = "aws_dynamodb_table_variable_name"
      dynamodb_table               = "my-dynamodb-table"


      custom = {
        organization_secrets = {
          secret1 = "secret1",
          secret2 = "secret2"
        }
        organization_variables = {
          variable1 = "variable1",
          variable2 = "variable2"
        }
        repository_secrets = {
          repo1 = {
            secret1 = "secret1",
            secret2 = "secret2"
          },
          repo2 = {
            secret1 = "secret1",
            secret2 = "secret2"
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
}

run "s3_bucket_test" {
  command = apply

  assert {
    condition     = github_actions_organization_variable.s3_bucket[0].variable_name == var.oidc_configuration.aws.s3_bucket_variable_name
    error_message = "s3_bucket variable name does not match. Expected: ${var.oidc_configuration.aws.s3_bucket_variable_name}, got: ${github_actions_organization_variable.s3_bucket[0].variable_name}"
  }
  assert {
    condition     = github_actions_organization_variable.s3_bucket[0].value == var.oidc_configuration.aws.s3_bucket
    error_message = "s3_bucket value does not match. Expected: ${var.oidc_configuration.aws.s3_bucket}, got: ${github_actions_organization_variable.s3_bucket[0].value}"
  }
  assert {
    condition     = github_actions_organization_variable.s3_bucket[0].visibility == "selected"
    error_message = "s3_bucket visibility does not match. Expected: selected, got: ${github_actions_organization_variable.s3_bucket[0].visibility}"
  }
}

run "region_test" {
  assert {
    condition     = github_actions_organization_variable.region[0].variable_name == var.oidc_configuration.aws.region_variable_name
    error_message = "region variable name does not match. Expected: ${var.oidc_configuration.aws.region_variable_name}, got: ${github_actions_organization_variable.region[0].variable_name}"
  }
  assert {
    condition     = github_actions_organization_variable.region[0].value == var.oidc_configuration.aws.region
    error_message = "region value does not match. Expected: ${var.oidc_configuration.aws.region}, got: ${github_actions_organization_variable.region[0].value}"
  }
  assert {
    condition     = github_actions_organization_variable.region[0].visibility == "selected"
    error_message = "region visibility does not match. Expected: selected, got: ${github_actions_organization_variable.region[0].visibility}"
  }
}

run "organizations_iam_role_test" {
  assert {
    condition     = github_actions_secret.organizations_iam_role[0].secret_name == var.oidc_configuration.aws.organizations_role_variable_name
    error_message = "organizations_iam_role secret name does not match. Expected: ${var.oidc_configuration.aws.organizations_role_variable_name}, got: ${github_actions_secret.organizations_iam_role[0].secret_name}"
  }
  assert {
    condition     = github_actions_secret.organizations_iam_role[0].plaintext_value == var.oidc_configuration.aws.organizations_role
    error_message = "organizations_iam_role plaintext value does not match. Expected: ${var.oidc_configuration.aws.organizations_role}, got: ${nonsensitive(github_actions_secret.organizations_iam_role[0].plaintext_value)}"
  }
}

run "dynamodb_table_name_test" {
  assert {
    condition     = github_actions_variable.dynamodb_table_name[0].variable_name == var.oidc_configuration.aws.dynamodb_table_variable_name
    error_message = "dynamodb_table_name variable name does not match. Expected: ${var.oidc_configuration.aws.dynamodb_table_variable_name}, got: ${github_actions_variable.dynamodb_table_name[0].variable_name}"
  }
  assert {
    condition     = github_actions_variable.dynamodb_table_name[0].value == var.oidc_configuration.aws.dynamodb_table
    error_message = "dynamodb_table_name value does not match. Expected: ${var.oidc_configuration.aws.dynamodb_table}, got: ${github_actions_variable.dynamodb_table_name[0].value}"
  }
}
