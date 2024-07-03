resource "github_actions_organization_variable" "s3_bucket" {
  count = var.oidc_configuration.aws != null ? 1 : 0

  variable_name = coalesce(var.oidc_configuration.aws.s3_bucket_variable_name, "AWS_S3_BUCKET")
  value         = var.oidc_configuration.aws.s3_bucket
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "region" {
  count = var.oidc_configuration.aws != null ? 1 : 0

  variable_name = coalesce(var.oidc_configuration.aws.region_variable_name, "AWS_REGION")
  value         = var.oidc_configuration.aws.region
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_secret" "organizations_iam_role" {
  count = var.oidc_configuration.aws != null ? 1 : 0

  repository      = github_repository.organizations_repo.name
  secret_name     = coalesce(var.oidc_configuration.aws.organizations_role_variable_name, "AWS_IAM_ROLE")
  plaintext_value = var.oidc_configuration.aws.organizations_role
}

resource "github_actions_variable" "dynamodb_table_name" {
  count = var.oidc_configuration.aws != null ? 1 : 0

  repository    = github_repository.organizations_repo.name
  variable_name = coalesce(var.oidc_configuration.aws.dynamodb_table_variable_name, "AWS_DYNAMO_DB_TABLE")
  value         = var.oidc_configuration.aws.dynamodb_table
}
