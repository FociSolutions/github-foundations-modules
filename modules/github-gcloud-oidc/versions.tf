terraform {
  required_version = ">= 1.7.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.77" # tftest
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.77" # tftest
    }
  }
}