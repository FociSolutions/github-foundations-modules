resource "github_repository_environment" "environemnt" {
  for_each    = keys(var.environments)
  repository  = github_repository.repository.name
  environment = each.value
}
