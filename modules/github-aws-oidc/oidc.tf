resource "aws_iam_openid_connect_provider" "oidc_provider_entry" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [ "sts.amazonaws.com" ]

  thumbprint_list = var.github_thumbprints

  tags = local.rg_tags
}

resource "aws_iam_role" "organizations_role" {
    name = var.organizations_role_name

    assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
        {
            "Effect" = "Allow",
            "Action" = "sts:AssumeRoleWithWebIdentity",
            "Principal" = {
                "Federated" = aws_iam_openid_connect_provider.oidc_provider_entry.arn
            },
            "Condition" = {
                "StringEquals" = {
                    "token.actions.githubusercontent.com:aud" = [
                        "sts.amazonaws.com"
                    ]
                },
                "StringLike" = {
                    "token.actions.githubusercontent.com:sub": [
                        "repo:${var.github_repo_owner}/${var.organizations_repo_name}:*"
                    ]
                }
            }
        }
    ]
})

    tags = local.rg_tags
}

resource "aws_iam_role_policy" "organizations_role_policy" {
    name = "organizations-tf-state-management-policy"
    role = aws_iam_role.organizations_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "StateBucketFullAccess"
                Action = [
                    "s3:*"
                ]
                Effect = "Allow"
                Resource = [
                    aws_s3_bucket.state_bucket.arn,
                    "${aws_s3_bucket.sate_bucket.arn}/*"    
                ]
            },
            {
                Sid = "StateBucketDeleteDeny"
                Action = [
                    "s3:DeleteBucket"
                ]
                Effect = "Deny"
                Resource = [aws_s3_bucket.state_bucket.arn]
            },
            {
                Sid = "AllowSecretRead"
                Action = [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret",
                    "secretsmanager:GetResourcePolicy"

                ]
                Effect = "Allow"
                Resource = "*"
                Condition = {
                    StringEquals = {
                        "secretsmanager:ResourceTag/Purpose" = local.rg_tags["Purpose"]
                    }
                }
            },
            {
                Sid = "AllowDynamoDBActionsOnLockTable"
                Effect = "Allow",
                Action = [
                    "dynamodb:DescribeTable",
                    "dynamodb:GetItem",
                    "dynamodb:PutItem",
                    "dynamodb:DeleteItem"
                ],
                Resource = [ aws_dynamodb_table.state_lock_table.arn ]
            }
        ]
    })
}