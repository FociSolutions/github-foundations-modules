terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.0.0" #tftest
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.77" # tftest
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6" # tftest
    }
  }
}
