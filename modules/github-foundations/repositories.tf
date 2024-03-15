locals {
  repos_with_drift_detection = [github_repository.organizations_repo]
}

#Creates the repository for the bootstrap layer
resource "github_repository" "bootstrap_repo" {
  name        = var.bootstrap_repository_name
  description = "The repository for the bootstrap layer of the foundations. This repository contains the Terraform code to setup the github organization for the foundation repositories, create the GCP project, the GCP service account, the GCP secret manager secrets, and the GCP storage bucket for the state files."

  visibility = "private"

  auto_init              = true
  delete_branch_on_merge = true
  vulnerability_alerts   = true

  lifecycle {
    ignore_changes = [
      auto_init
    ]
  }
}

resource "github_repository_collaborators" "bootstrap_repo_collaborators" {
  repository = github_repository.bootstrap_repo.name

  team {
    permission = "push"
    team_id    = github_team.foundation_devs.id
  }
}

#Creates the repository for the organizations layer
resource "github_repository" "organizations_repo" {
  name        = var.organizations_repository_name
  description = "The repository for the organizations layer of the foundations. This repository contains the Terraform code to manage github organizations under the enterprise account and their repositories, teams, and members."

  visibility = "private"

  auto_init              = true
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  has_issues             = true

  lifecycle {
    ignore_changes = [
      auto_init
    ]
  }
}

resource "github_repository_collaborators" "organization_repo_collaborators" {
  repository = github_repository.organizations_repo.name

  team {
    permission = "push"
    team_id    = github_team.foundation_devs.id
  }
}

resource "github_issue_labels" "drift_labels" {
  for_each = { for idx, val in local.repos_with_drift_detection : idx => val }

  repository = each.value.name

  label {
    name  = "Action Required"
    color = "FF0000"
  }

  label {
    name  = "Re-Apply"
    color = "0800FF"
  }

  label {
    color = "ededed"
    name  = "Drift"
  }
}
