locals {
  organization_action_secrets = distinct(flatten(concat(
    [for _, repo in var.public_repositories : repo.organization_action_secrets if repo.organization_action_secrets != null],
    [for _, repo in var.private_repositories : repo.organization_action_secrets if repo.organization_action_secrets != null]
  )))

  organization_action_secrets_repository_id_list = {
    for secret in local.organization_action_secrets : secret => toset(distinct(concat(
      [for repo_name, repo in var.public_repositories : module.public_repositories["${repo_name}"].id if contains(repo.organization_action_secrets, secret)],
      [for repo_name, repo in var.private_repositories : module.module.private_repositories["${repo_name}"].id if contains(repo.organization_action_secrets, secret)]
    )))
  }
}

resource "github_actions_organization_secret_repositories" "org_secret_repo_access" {
  for_each = local.organization_action_secrets_repository_id_list

  secret_name = each.key
  selected_repository_ids = each.value
}