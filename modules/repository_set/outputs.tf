output "repository_ids" {
  value = merge({
    for repository_name in keys(var.var.public_repositories) : repository_name => module.public_repositories["${repository_name}"].id
  }, {
    for repository_name in keys(var.var.private_repositories) : repository_name => module.private_repositories["${repository_name}"].id
  })
  description = "A map of github repository names to ids"
}