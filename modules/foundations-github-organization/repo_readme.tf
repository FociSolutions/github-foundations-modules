data "local_file" "main_readme" {
  filename = var.readme_path
}

resource "github_repository_file" "main_readme" {
  # Only create this when the readme filename is not empty
  count               = var.readme_path != "" ? 1 : 0
  repository          = github_repository.organizations_repo.name
  file                = "README.md"
  content             = data.local_file.main_readme.content
  depends_on          = [github_repository.organizations_repo]
  overwrite_on_create = true
}