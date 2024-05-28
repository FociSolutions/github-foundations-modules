locals {
  github_foundations_rg = (
    var.rg_create
    ? try(azurerm_resource_group.github_foundations_rg[0], null)
    : try(data.azurerm_resource_group.github_foundations_rg[0], null)
  )
}

data "azurerm_resource_group" "github_foundations_rg" {
  count  = var.rg_create ? 0 : 1
  name = var.rg_name
}
resource "azurerm_resource_group" "github_foundations_rg" {
  count = var.rg_create ? 1 : 0
  name     = var.rg_name
  location = var.rg_location
}