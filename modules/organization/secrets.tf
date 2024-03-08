resource "github_actions_organization_secret" "action_secret" {
  for_each = var.actions_secrets

  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = []

  lifecycle {
    ignore_changes = [selected_repository_ids]
  }
}

resource "github_codespaces_organization_secret" "codespace_secret" {
  for_each = var.codespaces_secrets

  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = []

  lifecycle {
    ignore_changes = [selected_repository_ids]
  }
}

resource "github_dependabot_organization_secret" "dependabot_secret" {
  for_each                = var.dependabot_secrets
  secret_name             = each.key
  encrypted_value         = each.value.encrypted_value
  visibility              = each.value.visibility
  selected_repository_ids = []

  lifecycle {
    ignore_changes = [selected_repository_ids]
  }
}
