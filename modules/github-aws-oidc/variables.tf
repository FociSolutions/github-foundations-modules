# Resource Group Variables
variable "rg_name" {
  type = string
  description = "The name of the AWS resource group to create for github foundation resources."
  default = "GithubFoundationResources"
}

# Bucket Variables
variable "bucket_name" {
  type = string
  description = "The name of the s3 bucket that will store terraform state."
  default = "GithubFoundationState"
}

# DynamoDB Variables
variable "tflock_db_name" {
  type = string
  description = "The name of the dynamodb table that will store lock file ids."
  default = "TFLockIds"
}

variable "tflock_db_read_capacity" {
  type = number
  description = "The read capacity to set for the dynamodb table storing lock file ids. Only required if billing mode is `PROVISIONED`. Defaults to 20."
  default = 20
}

variable "tflock_db_write_capacity" {
  type = number
  description = "The write capacity to set for the dynamodb table storing lock file ids. Only required if billing mode is `PROVISIONED`. Defaults to 20."
  default = 20
}

variable "tflock_db_billing_mode" {
  type = string
  description = "The billing mode to use for the dynamodb table storing lock file ids. Defaults to `PROVISIONED`."
  default = "PROVISIONED"
}

# IAM Variables

variable "github_thumbprints" {
  type = list(string)
  description = "A list of top intermediate certifact authority thumbprints to use for setting up an openid connect provider with github. Info on how to obtain thumbprints here: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html"
  validation {
    error_message = "The list must be a minimum length of 1 and has a maximum length of 5"
    condition = length(var.github_thumbprints) >=1 && length(var.github_thumbprints) <= 5
  }
}

variable "organizations_role_name" {
  type = string
  description = "The name of the role that will be assummed by the github runner for the organizations repository."
  default = "GhFoundationsOrganizationsAction"
}

variable "github_foundations_organization_name" {
  type = string
  description = "The owner of the github foundations organizations repository. This value should be whatever github account you plan to make the repository under."
}

variable "organizations_repo_name" {
  type = string
  description = "The name of the github foundations organizations repository. Defaults to `organizations`"
  default = "organizations"
}