terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.12.0" # tftest
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.12.0" # tftest
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6" # tftest
    }
  }
}
