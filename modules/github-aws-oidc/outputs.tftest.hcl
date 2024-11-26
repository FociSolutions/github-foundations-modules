mock_provider "github" {}
mock_provider "aws" {}

override_resource {
  target = aws_s3_bucket.state_bucket
  values = {
    region = "us-west-2"
  }
}
override_resource {
  target = aws_iam_role.organizations_role
  values = {
    arn = "arn:aws:iam::123456789012:role/GhFoundationsOrganizationsAction"
  }
}

variables {
  # required variables
  github_foundations_organization_name = "github-foundations-org"
  github_thumbprints                   = ["990F4193972F2BECF12DDEDA5237F9C952F20D9E"]

  # Variables for this test
  bucket_name = "GithubFoundationStateBuckettyBucket"
}

run "create_test" {
  command = apply

  assert {
    condition     = output.s3_bucket_name == var.bucket_name
    error_message = "The name of the state bucket is incorrect. Expected '${var.bucket_name}' but got '${output.s3_bucket_name}'."
  }
  assert {
    condition     = output.s3_bucket_region == "us-west-2"
    error_message = "The region of the state bucket is incorrect. Expected 'us-west-2' but got '${output.s3_bucket_region}'."
  }
  assert {
    condition     = output.dynamodb_table_name == "TFLockIds"
    error_message = "The name of the dynamodb table is incorrect. Expected 'TFLockIds' but got '${output.dynamodb_table_name}'."
  }
  assert {
    condition     = output.organizations_runner_role == "arn:aws:iam::123456789012:role/GhFoundationsOrganizationsAction"
    error_message = "The ARN of the role is incorrect. Expected 'arn:aws:iam::123456789012:role/GhFoundationsOrganizationsAction' but got '${output.organizations_runner_role}'."
  }
}
