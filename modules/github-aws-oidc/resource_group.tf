locals {
  rg_tags = {
    Purpose = "Github Foundations"
  }
}

# resource  "aws_resourcegroups_group" "github_foundations_rg" {
#   name = var.rg_name

#   resource_query {
#     query = <<JSON
#     {

#     }
#     JSON
#   }
# }
