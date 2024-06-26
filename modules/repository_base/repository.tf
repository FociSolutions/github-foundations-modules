locals {
  enable_dependabot_automated_security_fixes = var.has_vulnerability_alerts && var.dependabot_security_updates ? 1 : 0
  can_configure_security_and_analysis        = var.advance_security || var.secret_scanning || var.secret_scanning_on_push

  protected_branches_refs = [
    for branch in var.protected_branches : "refs/heads/${branch}"
  ]
}

resource "github_repository" "repository" {
  name        = var.name
  description = var.description
  #trivy:ignore:avd-git-0001
  visibility = var.visibility

  auto_init                   = true
  archive_on_destroy          = false
  has_downloads               = var.has_downloads
  has_issues                  = var.has_issues
  has_projects                = var.has_projects
  has_wiki                    = var.has_wiki
  has_discussions             = var.has_discussions
  vulnerability_alerts        = var.has_vulnerability_alerts
  topics                      = var.topics
  homepage_url                = var.homepage
  delete_branch_on_merge      = var.delete_head_on_merge
  allow_auto_merge            = var.allow_auto_merge
  allow_squash_merge          = var.allow_squash_merge
  squash_merge_commit_message = var.squash_merge_commit_message
  squash_merge_commit_title   = var.squash_merge_commit_title
  allow_merge_commit          = var.allow_merge_commit
  merge_commit_message        = var.merge_commit_message
  merge_commit_title          = var.merge_commit_title
  allow_rebase_merge          = var.allow_rebase_merge
  web_commit_signoff_required = var.requires_web_commit_signing
  license_template            = var.license_template


  # A hacky way of getting around the 422 errors received from github api
  dynamic "security_and_analysis" {
    for_each = local.can_configure_security_and_analysis ? [1] : []
    content {
      dynamic "advanced_security" {
        for_each = var.advance_security ? [var.advance_security] : []
        content {
          status = "enabled"
        }
      }

      dynamic "secret_scanning" {
        for_each = var.secret_scanning ? [var.secret_scanning] : []
        content {
          status = "enabled"
        }
      }

      dynamic "secret_scanning_push_protection" {
        for_each = var.secret_scanning_on_push ? [var.secret_scanning_on_push] : []
        content {
          status = "enabled"
        }
      }
    }
  }

  # Use a template repo if one is specified
  dynamic "template" {
    for_each = var.template_repository == null ? [] : [1]
    content {
      owner                = var.template_repository.owner
      repository           = var.template_repository.repository
      include_all_branches = var.template_repository.include_all_branches
    }
  }

  dynamic "pages" {
    for_each = var.pages == null ? [] : [1]
    content {
      dynamic "source" {
        for_each = var.pages.source == null ? [] : [1]
        content {
          branch = var.pages.source.branch
          path   = var.pages.source.path
        }
      }
      build_type = var.pages.build_type
      cname      = var.pages.cname
    }
  }
}

resource "github_repository_dependabot_security_updates" "automated_security_fixes" {
  count      = local.enable_dependabot_automated_security_fixes
  repository = github_repository.repository.name
  enabled    = true
}

resource "github_branch_default" "default_branch" {
  repository = github_repository.repository.name
  branch     = var.default_branch
}

resource "github_repository_ruleset" "protected_branch_base_rules" {
  count = length(toset(local.protected_branches_refs)) > 0 ? 1 : 0

  name        = "protected_branch_base_ruleset"
  repository  = github_repository.repository.name
  target      = "branch"
  enforcement = "active"
  rules {
    deletion = true
    creation = false
    update   = false
    pull_request {
      dismiss_stale_reviews_on_push   = true
      require_last_push_approval      = true
      required_approving_review_count = 1
    }
    non_fast_forward = true
  }

  conditions {
    ref_name {
      exclude = []
      include = toset(local.protected_branches_refs)
    }
  }
}
