mock_provider "github" {}
mock_provider "aws" {}

variables {
  # required variables
  github_foundations_organization_name = "github-foundations-org"
  github_thumbprints                   = ["990F4193972F2BECF12DDEDA5237F9C952F20D9E"]
}

run "oidc_provider_entry_test" {
  command = apply

  assert {
    condition     = aws_iam_openid_connect_provider.oidc_provider_entry.url == "https://token.actions.githubusercontent.com"
    error_message = "The url of the openid connect provider entry is incorrect. Expected 'https://token.actions.githubusercontent.com' but got '${aws_iam_openid_connect_provider.oidc_provider_entry.url}'."
  }
  assert {
    condition     = aws_iam_openid_connect_provider.oidc_provider_entry.client_id_list != null
    error_message = "The client id list of the openid connect provider entry is incorrect. Expected a non-null value but got 'null'."
  }
  assert {
    condition     = aws_iam_openid_connect_provider.oidc_provider_entry.thumbprint_list[0] == "990F4193972F2BECF12DDEDA5237F9C952F20D9E"
    error_message = "The thumbprint list of the openid connect provider entry is incorrect. Expected '990F4193972F2BECF12DDEDA5237F9C952F20D9E' but got '${aws_iam_openid_connect_provider.oidc_provider_entry.thumbprint_list[0]}'."
  }
}

run "organizations_role_test" {

  assert {
    condition     = aws_iam_role.organizations_role.name == "GhFoundationsOrganizationsAction"
    error_message = "The name of the organizations role is incorrect. Expected 'GhFoundationsOrganizationsAction' but got '${aws_iam_role.organizations_role.name}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Effect"] == "Allow"
    error_message = "The assume role policy of the organizations role is incorrect. Expected 'Allow' but got '${jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Effect"]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Action"] == "sts:AssumeRoleWithWebIdentity"
    error_message = "The assume role policy action of the organizations role is incorrect. Expected 'sts:AssumeRoleWithWebIdentity' but got '${jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Action"]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Principal"]["Federated"] == aws_iam_openid_connect_provider.oidc_provider_entry.arn
    error_message = "The assume role policy principal federated of the organizations role is incorrect. Expected '${aws_iam_openid_connect_provider.oidc_provider_entry.arn}' but got '${jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Principal"]["Federated"]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Condition"]["StringEquals"]["token.actions.githubusercontent.com:aud"][0] == "sts.amazonaws.com"
    error_message = "The assume role policy condition string equals token actions githubusercontent com aud of the organizations role is incorrect. Expected 'sts.amazonaws.com' but got '${jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Condition"]["StringEquals"]["token.actions.githubusercontent.com:aud"][0]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Condition"]["StringLike"]["token.actions.githubusercontent.com:sub"][0] == "repo:github-foundations-org/organizations:*"
    error_message = "The assume role policy condition string like token actions githubusercontent com sub of the organizations role is incorrect. Expected 'repo:github-foundations-org/organizations:*' but got '${jsondecode(aws_iam_role.organizations_role.assume_role_policy)["Statement"][0]["Condition"]["StringLike"]["token.actions.githubusercontent.com:sub"][0]}'."
  }
  assert {
    condition     = aws_iam_role.organizations_role.tags.Purpose == "Github Foundations"
    error_message = "The tags of the organizations role are incorrect. Expected 'Github Foundations' but got '${aws_iam_role.organizations_role.tags.Purpose}'."
  }
}

run "organizations_role_policy_test" {

  assert {
    condition     = aws_iam_role_policy.organizations_role_policy.name == "organizations-tf-state-management-policy"
    error_message = "The name of the organizations role policy is incorrect. Expected 'organizations-tf-state-management-policy' but got '${aws_iam_role_policy.organizations_role_policy.name}'."
  }
  assert {
    condition     = aws_iam_role_policy.organizations_role_policy.role == aws_iam_role.organizations_role.id
    error_message = "The role of the organizations role policy is incorrect. Expected '${aws_iam_role.organizations_role.id}' but got '${aws_iam_role_policy.organizations_role_policy.role}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Sid"] == "StateBucketFullAccess"
    error_message = "The organizations role policy statement sid is incorrect. Expected 'StateBucketFullAccess' but got '${jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Sid"]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Action"][0] == "s3:PutObject"
    error_message = "The organizations role policy statement action is incorrect. Expected 's3:PutObject' but got '${jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Action"][0]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Action"][1] == "s3:GetObject"
    error_message = "The organizations role policy statement action is incorrect. Expected 's3:GetObject' but got '${jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Action"][1]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Action"][2] == "s3:ListBucket"
    error_message = "The organizations role policy statement action is incorrect. Expected 's3:ListBucket' but got '${jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Action"][2]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Effect"] == "Allow"
    error_message = "The organizations role policy statement effect is incorrect. Expected 'Allow' but got '${jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Effect"]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Resource"][0] == aws_s3_bucket.state_bucket.arn
    error_message = "The organizations role policy statement resource is incorrect. Expected '${aws_s3_bucket.state_bucket.arn}' but got '${jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Resource"][0]}'."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Resource"][1] == "${aws_s3_bucket.state_bucket.arn}/*"
    error_message = "The organizations role policy statement resource is incorrect. Expected '${aws_s3_bucket.state_bucket.arn}/*' but got '${jsondecode(aws_iam_role_policy.organizations_role_policy.policy)["Statement"][0]["Resource"][1]}'."
  }
}
