terraform {
  required_version = ">= 1.7.1"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.1.0"
    }
  }
}
