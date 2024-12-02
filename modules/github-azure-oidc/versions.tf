terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.7.0" #tftest
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6" # tftest
    }
  }
}
