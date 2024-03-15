resource "github_enterprise_organization" "organization" {
  enterprise_id = var.enterprise_id
  name          = var.name
  display_name  = length(var.display_name) > 0 ? var.display_name : var.name
  description   = var.description
  billing_email = var.billing_email
  admin_logins  = var.admin_logins
}

