data "local_file" "main_readme" {
  count    = var.readme_path != "" ? 1 : 0
  filename = var.readme_path
}

resource "github_repository_file" "main_readme" {
  # Only create this when the readme filename is not empty
  count      = var.readme_path != "" ? 1 : 0
  depends_on = [github_repository.organizations_repo]
  repository = github_repository.organizations_repo.name
  file       = "README.md"
  content    = data.local_file.main_readme[0].content
}