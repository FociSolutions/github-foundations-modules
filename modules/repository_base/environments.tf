resource "github_repository_environment" "environment" {
  for_each    = toset(keys(coalesce(var.environments, {})))
  repository  = github_repository.repository.name
  environment = each.value
}
