locals {
  coalesced_public_repositories  = coalesce(var.public_repositories, {})
  coalesced_private_repositories = coalesce(var.private_repositories, {})

  organization_action_secrets = distinct(flatten(concat(
    [for _, repo in local.coalesced_public_repositories : repo.organization_action_secrets if repo.organization_action_secrets != null],
    [for _, repo in local.coalesced_private_repositories : repo.organization_action_secrets if repo.organization_action_secrets != null]
  )))

  organization_action_secrets_repository_id_list = {
    for secret in local.organization_action_secrets : secret => toset(distinct(concat(
      [for repo_name, repo in local.coalesced_public_repositories : module.public_repositories[repo_name].id if contains(coalesce(repo.organization_action_secrets, []), secret)],
      [for repo_name, repo in local.coalesced_private_repositories : module.private_repositories[repo_name].id if contains(coalesce(repo.organization_action_secrets, []), secret)]
    )))
  }

  codespace_secrets = distinct(flatten(concat(
    [for _, repo in local.coalesced_public_repositories : repo.organization_codespace_secrets if repo.organization_codespace_secrets != null],
    [for _, repo in local.coalesced_private_repositories : repo.organization_codespace_secrets if repo.organization_codespace_secrets != null]
  )))

  codespace_secrets_repository_id_list = {
    for secret in local.codespace_secrets : secret => toset(distinct(concat(
      [for repo_name, repo in local.coalesced_public_repositories : module.public_repositories[repo_name].id if contains(coalesce(repo.organization_codespace_secrets, []), secret)],
      [for repo_name, repo in local.coalesced_private_repositories : module.private_repositories[repo_name].id if contains(coalesce(repo.organization_codespace_secrets, []), secret)]
    )))
  }

  dependabot_secrets = distinct(flatten(concat(
    [for _, repo in local.coalesced_public_repositories : repo.organization_dependabot_secrets if repo.organization_dependabot_secrets != null],
    [for _, repo in local.coalesced_private_repositories : repo.organization_dependabot_secrets if repo.organization_dependabot_secrets != null]
  )))

  dependabot_secrets_id_list = {
    for secret in local.dependabot_secrets : secret => toset(distinct(concat(
      [for repo_name, repo in local.coalesced_public_repositories : module.public_repositories[repo_name].id if contains(coalesce(repo.organization_dependabot_secrets, []), secret)],
      [for repo_name, repo in local.coalesced_private_repositories : module.private_repositories[repo_name].id if contains(coalesce(repo.organization_dependabot_secrets, []), secret)]
    )))
  }
}

resource "github_actions_organization_secret_repositories" "org__action_secret_repo_access" {
  for_each = local.organization_action_secrets_repository_id_list

  secret_name             = each.key
  selected_repository_ids = each.value
}

resource "github_codespaces_organization_secret_repositories" "org__codespace_secret_repo_access" {
  for_each = local.codespace_secrets_repository_id_list

  secret_name             = each.key
  selected_repository_ids = each.value
}

resource "github_dependabot_organization_secret_repositories" "org__dependabot_secret_repo_access" {
  for_each = local.dependabot_secrets_id_list

  secret_name             = each.key
  selected_repository_ids = each.value
}
