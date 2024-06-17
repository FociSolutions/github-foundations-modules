output "s3_bucket_name" {
  description = "The name of the s3 bucket holding terraform state."
  value = aws_s3_bucket.state_bucket.bucket
}

output "s3_bucket_region" {
  description = "The region the s3 bucket holding terraform state was created in."
  value = aws_s3_bucket.state_bucket.region
}

output "dynamodb_table_name" {
  description = "The name of the dynamodb table that was created to store lock file ids."
  value = aws_dynamodb_table.state_lock_table.name
}

output "organizations_runner_role" {
  description = "The ARN of the role that the github action runner should assume for the organizations repo"
  value = aws_iam_role.organizations_role.arn
}