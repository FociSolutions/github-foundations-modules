terraform {
  required_version = ">= 1.3"
  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "5.44.0"
    }
  }
}
