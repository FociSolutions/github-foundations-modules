terraform {
  required_version = ">= 1.7.1"
  required_providers {
    github = {
      source                = "hashicorp/github"
      version               = "5.44.0"
      configuration_aliases = [github.enterprise_scoped, github.foundation_org_scoped]
    }
  }
}
