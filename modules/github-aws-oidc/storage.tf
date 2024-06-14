resource "aws_kms_key" "encryption_key" {
  description             = "This key is used to encrypt state bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = var.bucket_name

  tags = local.rg_tags
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "state_lock_table" {
  name           = var.tflock_db_name
  read_capacity  = var.tflock_db_read_capacity
  write_capacity = var.tflock_db_write_capacity
  billing_mode   = var.tflock_db_billing_mode
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.rg_tags
}
