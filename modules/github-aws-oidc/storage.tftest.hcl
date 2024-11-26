mock_provider "github" {}
mock_provider "aws" {}

variables {
  # required variables
  github_foundations_organization_name = "github-foundations-org"

  # Variables for this test
  github_thumbprints = ["990F4193972F2BECF12DDEDA5237F9C952F20D9E", "990F4193972F2BECF12DDEDA5237F9C952F20D9F"]
}

run "encryption_key_test" {
  command = apply

  assert {
    condition     = aws_kms_key.encryption_key.description == "This key is used to encrypt state bucket objects"
    error_message = "The description of the encryption key is incorrect. Expected 'This key is used to encrypt state bucket objects' but got '${aws_kms_key.encryption_key.description}'."
  }
  assert {
    condition     = aws_kms_key.encryption_key.deletion_window_in_days == 10
    error_message = "The deletion window in days of the encryption key is incorrect. Expected 10 but got ${aws_kms_key.encryption_key.deletion_window_in_days}."
  }
  assert {
    condition     = aws_kms_key.encryption_key.enable_key_rotation == true
    error_message = "The enable key rotation of the encryption key is incorrect. Expected true but got ${aws_kms_key.encryption_key.enable_key_rotation}."
  }
  assert {
    condition     = aws_kms_key.encryption_key.tags.Purpose == "Github Foundations"
    error_message = "The tags of the encryption key are incorrect. Expected 'Github Foundations' but got '${aws_kms_key.encryption_key.tags.Purpose}'."
  }
}

run "state_bucket_test" {
  assert {
    condition     = aws_s3_bucket.state_bucket.bucket == "GithubFoundationState"
    error_message = "The name of the state bucket is incorrect. Expected 'GithubFoundationState' but got '${aws_s3_bucket.state_bucket.bucket}'."
  }
  assert {
    condition     = aws_s3_bucket.state_bucket.tags.Purpose == "Github Foundations"
    error_message = "The tags of the state bucket are incorrect. Expected 'Github Foundations' but got '${aws_s3_bucket.state_bucket.tags.Purpose}'."
  }
}

run "state_bucket_versioning_test" {
  assert {
    condition     = aws_s3_bucket_versioning.state_bucket_versioning.bucket == aws_s3_bucket.state_bucket.id
    error_message = "The state bucket versioning configuration is incorrect. Expected '${aws_s3_bucket.state_bucket.id}' but got '${aws_s3_bucket_versioning.state_bucket_versioning.bucket}'."
  }
  assert {
    condition     = aws_s3_bucket_versioning.state_bucket_versioning.versioning_configuration[0].status == "Enabled"
    error_message = "The state bucket versioning status is incorrect. Expected 'Enabled' but got '${aws_s3_bucket_versioning.state_bucket_versioning.versioning_configuration[0].status}'."
  }
}

run "state_bucket_encryption_test" {
  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.state_bucket_encryption.bucket == aws_s3_bucket.state_bucket.id
    error_message = "The state bucket encryption configuration is incorrect. Expected '${aws_s3_bucket.state_bucket.id}' but got '${aws_s3_bucket_server_side_encryption_configuration.state_bucket_encryption.bucket}'."
  }
  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.state_bucket_encryption.rule != null
    error_message = "The state bucket encryption rule is incorrect. Expected 1 but got null."
  }
}

run "state_bucket_access_test" {
  assert {
    condition     = aws_s3_bucket_public_access_block.state_bucket_access.bucket == aws_s3_bucket.state_bucket.id
    error_message = "The state bucket access configuration is incorrect. Expected '${aws_s3_bucket.state_bucket.id}' but got '${aws_s3_bucket_public_access_block.state_bucket_access.bucket}'."
  }
  assert {
    condition     = aws_s3_bucket_public_access_block.state_bucket_access.block_public_acls == true
    error_message = "The state bucket access block public acls is incorrect. Expected true but got '${aws_s3_bucket_public_access_block.state_bucket_access.block_public_acls}'."
  }
  assert {
    condition     = aws_s3_bucket_public_access_block.state_bucket_access.block_public_policy == true
    error_message = "The state bucket access block public policy is incorrect. Expected true but got '${aws_s3_bucket_public_access_block.state_bucket_access.block_public_policy}'."
  }
  assert {
    condition     = aws_s3_bucket_public_access_block.state_bucket_access.ignore_public_acls == true
    error_message = "The state bucket access ignore public acls is incorrect. Expected true but got '${aws_s3_bucket_public_access_block.state_bucket_access.ignore_public_acls}'."
  }
  assert {
    condition     = aws_s3_bucket_public_access_block.state_bucket_access.restrict_public_buckets == true
    error_message = "The state bucket access restrict public buckets is incorrect. Expected true but got '${aws_s3_bucket_public_access_block.state_bucket_access.restrict_public_buckets}'."
  }
}

run "state_lock_table_test" {
  assert {
    condition     = aws_dynamodb_table.state_lock_table.name == "TFLockIds"
    error_message = "The name of the state lock table is incorrect. Expected 'TFLockIds' but got '${aws_dynamodb_table.state_lock_table.name}'."
  }
  assert {
    condition     = aws_dynamodb_table.state_lock_table.read_capacity == 20
    error_message = "The read capacity of the state lock table is incorrect. Expected 20 but got '${aws_dynamodb_table.state_lock_table.read_capacity}'."
  }
  assert {
    condition     = aws_dynamodb_table.state_lock_table.write_capacity == 20
    error_message = "The write capacity of the state lock table is incorrect. Expected 20 but got '${aws_dynamodb_table.state_lock_table.write_capacity}'."
  }
  assert {
    condition     = aws_dynamodb_table.state_lock_table.billing_mode == "PROVISIONED"
    error_message = "The billing mode of the state lock table is incorrect. Expected 'PROVISIONED' but got '${aws_dynamodb_table.state_lock_table.billing_mode}'."
  }
  assert {
    condition     = aws_dynamodb_table.state_lock_table.hash_key == "LockID"
    error_message = "The hash key of the state lock table is incorrect. Expected 'LockID' but got '${aws_dynamodb_table.state_lock_table.hash_key}'."
  }
  assert {
    condition     = aws_dynamodb_table.state_lock_table.point_in_time_recovery[0].enabled == true
    error_message = "The point in time recovery of the state lock table is incorrect. Expected true but got '${aws_dynamodb_table.state_lock_table.point_in_time_recovery[0].enabled}'."
  }
  assert {
    condition     = aws_dynamodb_table.state_lock_table.attribute != null
    error_message = "The number of attributes of the state lock table is incorrect. Expected 1 but got null."
  }
  assert {
    condition     = aws_dynamodb_table.state_lock_table.tags.Purpose == "Github Foundations"
    error_message = "The tags of the state lock table are incorrect. Expected 'Github Foundations' but got '${aws_dynamodb_table.state_lock_table.tags.Purpose}'."
  }
}
