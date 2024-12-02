mock_provider "github" {}

variables {
  name                        = "github-foundations-modules"
  description                 = "A collection of terraform modules used in the Github Foundations framework."
  visibility                  = "public"
  has_downloads               = true
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  has_discussions             = true
  has_vulnerability_alerts    = true
  topics                      = ["terraform", "github", "foundations"]
  homepage                    = "myhomepage"
  delete_head_on_merge        = false
  allow_auto_merge            = true
  allow_squash_merge          = false
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  allow_merge_commit          = false
  merge_commit_message        = "PR_BODY"
  merge_commit_title          = "PR_TITLE"
  allow_rebase_merge          = true
  requires_web_commit_signing = false
  license_template            = "mit"
  dependabot_security_updates = true
  advance_security            = true
  secret_scanning             = true
  secret_scanning_on_push     = true

  default_branch     = "main"
  protected_branches = ["main", "develop"]

  template_repository = {
    owner                = "owner"
    repository           = "template_repository"
    include_all_branches = true
  }

  pages = {
    source = {
      branch = "main"
      path   = "path"
    }
    cname = "cname"
  }

  repository_team_permissions = {
    "repo_team1" = "push"
    "repo_team2" = "admin"
  }
  repository_user_permissions = {
    "user1" = "push"
    "user2" = "admin"
  }
}

run "repository_test" {
  assert {
    condition     = github_repository.repository.name == var.name
    error_message = "Repository name does not match. Expected: ${var.name}, Actual: ${github_repository.repository.name}"
  }
  assert {
    condition     = github_repository.repository.description == var.description
    error_message = "Repository description does not match. Expected: ${var.description}, Actual: ${github_repository.repository.description}"
  }
  assert {
    condition     = github_repository.repository.visibility == var.visibility
    error_message = "Repository visibility does not match. Expected: ${var.visibility}, Actual: ${github_repository.repository.visibility}"
  }
  assert {
    condition     = github_repository.repository.auto_init == true
    error_message = "Repository auto_init does not match. Expected: true, Actual: ${github_repository.repository.auto_init}"
  }
  assert {
    condition     = github_repository.repository.archive_on_destroy == false
    error_message = "Repository archive_on_destroy does not match. Expected: false, Actual: ${github_repository.repository.archive_on_destroy}"
  }
  assert {
    condition     = github_repository.repository.has_downloads == var.has_downloads
    error_message = "Repository has_downloads does not match. Expected: ${var.has_downloads}, Actual: ${github_repository.repository.has_downloads}"
  }
  assert {
    condition     = github_repository.repository.has_issues == var.has_issues
    error_message = "Repository has_issues does not match. Expected: ${var.has_issues}, Actual: ${github_repository.repository.has_issues}"
  }
  assert {
    condition     = github_repository.repository.has_projects == var.has_projects
    error_message = "Repository has_projects does not match. Expected: ${var.has_projects}, Actual: ${github_repository.repository.has_projects}"
  }
  assert {
    condition     = github_repository.repository.has_wiki == var.has_wiki
    error_message = "Repository has_wiki does not match. Expected: ${var.has_wiki}, Actual: ${github_repository.repository.has_wiki}"
  }
  assert {
    condition     = github_repository.repository.has_discussions == var.has_discussions
    error_message = "Repository has_discussions does not match. Expected: ${var.has_discussions}, Actual: ${github_repository.repository.has_discussions}"
  }
  assert {
    condition     = github_repository.repository.vulnerability_alerts == var.has_vulnerability_alerts
    error_message = "Repository vulnerability_alerts does not match. Expected: ${var.has_vulnerability_alerts}, Actual: ${github_repository.repository.vulnerability_alerts}"
  }
  assert {
    condition     = length(github_repository.repository.topics) == length(var.topics)
    error_message = "Repository topics length does not match. Expected: ${length(var.topics)}, Actual: ${length(github_repository.repository.topics)}"
  }
  assert {
    condition     = github_repository.repository.homepage_url == var.homepage
    error_message = "Repository homepage does not match. Expected: ${var.homepage}, Actual: ${github_repository.repository.homepage_url}"
  }
  assert {
    condition     = github_repository.repository.delete_branch_on_merge == var.delete_head_on_merge
    error_message = "Repository delete_branch_on_merge does not match. Expected: ${var.delete_head_on_merge}, Actual: ${github_repository.repository.delete_branch_on_merge}"
  }
  assert {
    condition     = github_repository.repository.allow_auto_merge == var.allow_auto_merge
    error_message = "Repository allow_auto_merge does not match. Expected: ${var.allow_auto_merge}, Actual: ${github_repository.repository.allow_auto_merge}"
  }
  assert {
    condition     = github_repository.repository.allow_squash_merge == var.allow_squash_merge
    error_message = "Repository allow_squash_merge does not match. Expected: ${var.allow_squash_merge}, Actual: ${github_repository.repository.allow_squash_merge}"
  }
  assert {
    condition     = github_repository.repository.squash_merge_commit_message == var.squash_merge_commit_message
    error_message = "Repository squash_merge_commit_message does not match. Expected: ${var.squash_merge_commit_message}, Actual: ${github_repository.repository.squash_merge_commit_message}"
  }
  assert {
    condition     = github_repository.repository.squash_merge_commit_title == var.squash_merge_commit_title
    error_message = "Repository squash_merge_commit_title does not match. Expected: ${var.squash_merge_commit_title}, Actual: ${github_repository.repository.squash_merge_commit_title}"
  }
  assert {
    condition     = github_repository.repository.allow_merge_commit == var.allow_merge_commit
    error_message = "Repository allow_merge_commit does not match. Expected: ${var.allow_merge_commit}, Actual: ${github_repository.repository.allow_merge_commit}"
  }
  assert {
    condition     = github_repository.repository.merge_commit_message == var.merge_commit_message
    error_message = "Repository merge_commit_message does not match. Expected: ${var.merge_commit_message}, Actual: ${github_repository.repository.merge_commit_message}"
  }
  assert {
    condition     = github_repository.repository.merge_commit_title == var.merge_commit_title
    error_message = "Repository merge_commit_title does not match. Expected: ${var.merge_commit_title}, Actual: ${github_repository.repository.merge_commit_title}"
  }
  assert {
    condition     = github_repository.repository.allow_rebase_merge == var.allow_rebase_merge
    error_message = "Repository allow_rebase_merge does not match. Expected: ${var.allow_rebase_merge}, Actual: ${github_repository.repository.allow_rebase_merge}"
  }
  assert {
    condition     = github_repository.repository.web_commit_signoff_required == var.requires_web_commit_signing
    error_message = "Repository web_commit_signoff_required does not match. Expected: ${var.requires_web_commit_signing}, Actual: ${github_repository.repository.web_commit_signoff_required}"
  }
  assert {
    condition     = github_repository.repository.license_template == var.license_template
    error_message = "Repository license_template does not match. Expected: ${var.license_template}, Actual: ${github_repository.repository.license_template}"
  }
  assert {
    condition     = github_repository.repository.security_and_analysis[0].advanced_security[0].status == "enabled"
    error_message = "Repository advanced_security status does not match. Expected: enabled, Actual: ${github_repository.repository.security_and_analysis[0].advanced_security[0].status}"
  }
  assert {
    condition     = github_repository.repository.security_and_analysis[0].secret_scanning[0].status == "enabled"
    error_message = "Repository secret_scanning status does not match. Expected: enabled, Actual: ${github_repository.repository.security_and_analysis[0].secret_scanning[0].status}"
  }
  assert {
    condition     = github_repository.repository.security_and_analysis[0].secret_scanning_push_protection[0].status == "enabled"
    error_message = "Repository secret_scanning_push_protection status does not match. Expected: enabled, Actual: ${github_repository.repository.security_and_analysis[0].secret_scanning_push_protection[0].status}"
  }
  assert {
    condition     = github_repository.repository.template[0].owner == var.template_repository.owner
    error_message = "Repository template owner does not match. Expected: ${var.template_repository.owner}, Actual: ${github_repository.repository.template[0].owner}"
  }
  assert {
    condition     = github_repository.repository.template[0].repository == var.template_repository.repository
    error_message = "Repository template repository does not match. Expected: ${var.template_repository.repository}, Actual: ${github_repository.repository.template[0].repository}"
  }
  assert {
    condition     = github_repository.repository.template[0].include_all_branches == var.template_repository.include_all_branches
    error_message = "Repository template include_all_branches does not match. Expected: ${var.template_repository.include_all_branches}, Actual: ${github_repository.repository.template[0].include_all_branches}"
  }
  assert {
    condition     = github_repository.repository.pages[0].source[0].branch == var.pages.source.branch
    error_message = "Repository pages source branch does not match. Expected: ${var.pages.source.branch}, Actual: ${github_repository.repository.pages[0].source[0].branch}"
  }
  assert {
    condition     = github_repository.repository.pages[0].source[0].path == var.pages.source.path
    error_message = "Repository pages source path does not match. Expected: ${var.pages.source.path}, Actual: ${github_repository.repository.pages[0].source[0].path}"
  }
  assert {
    condition     = github_repository.repository.pages[0].cname == var.pages.cname
    error_message = "Repository pages cname does not match. Expected: ${var.pages.cname}, Actual: ${github_repository.repository.pages[0].cname}"
  }
}

run "automated_security_fixes_test" {
  assert {
    condition     = length(github_repository_dependabot_security_updates.automated_security_fixes) == 1
    error_message = "Repository automated_security_fixes count does not match. Expected: 1, Actual: ${length(github_repository_dependabot_security_updates.automated_security_fixes)}"
  }
  assert {
    condition     = github_repository_dependabot_security_updates.automated_security_fixes[0].repository == var.name
    error_message = "Repository automated_security_fixes repository does not match. Expected: ${var.name}, Actual: ${github_repository_dependabot_security_updates.automated_security_fixes[0].repository}"
  }
  assert {
    condition     = github_repository_dependabot_security_updates.automated_security_fixes[0].enabled == var.dependabot_security_updates
    error_message = "Repository automated_security_fixes enabled does not match. Expected: ${var.dependabot_security_updates}, Actual: ${github_repository_dependabot_security_updates.automated_security_fixes[0].enabled}"
  }
}

run "default_branch_test" {
  assert {
    condition     = github_branch_default.default_branch.repository == var.name
    error_message = "Repository default_branch repository does not match. Expected: ${var.name}, Actual: ${github_branch_default.default_branch.repository}"
  }
  assert {
    condition     = github_branch_default.default_branch.branch == var.default_branch
    error_message = "Repository default_branch branch does not match. Expected: ${var.default_branch}, Actual: ${github_branch_default.default_branch.branch}"
  }
}

run "protected_branch_base_rules_test" {
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].name == "protected_branch_base_ruleset"
    error_message = "Repository protected_branch_base_rules name does not match. Expected: protected_branch_base_ruleset, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].name}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].repository == var.name
    error_message = "Repository protected_branch_base_rules repository does not match. Expected: ${var.name}, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].repository}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].target == "branch"
    error_message = "Repository protected_branch_base_rules target does not match. Expected: branch, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].target}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].enforcement == "active"
    error_message = "Repository protected_branch_base_rules enforcement does not match. Expected: active, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].enforcement}"
  }
  # test the rules
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].rules[0].deletion == true
    error_message = "Repository protected_branch_base_rules rules deletion does not match. Expected: true, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].rules[0].deletion}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].rules[0].creation == false
    error_message = "Repository protected_branch_base_rules rules creation does not match. Expected: false, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].rules[0].creation}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].rules[0].update == false
    error_message = "Repository protected_branch_base_rules rules update does not match. Expected: false, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].rules[0].update}"
  }
  # Rule Pull Request
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].rules[0].pull_request[0].dismiss_stale_reviews_on_push == true
    error_message = "Repository protected_branch_base_rules rules pull_request.dismiss_stale_reviews_on_push does not match. Expected: true, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].rules[0].pull_request[0].dismiss_stale_reviews_on_push}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].rules[0].pull_request[0].require_last_push_approval == true
    error_message = "Repository protected_branch_base_rules rules pull_request.require_last_push_approval does not match. Expected: true, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].rules[0].pull_request[0].require_last_push_approval}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].rules[0].pull_request[0].required_approving_review_count == 1
    error_message = "Repository protected_branch_base_rules rules pull_request.required_approving_review_count does not match. Expected: 1, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].rules[0].pull_request[0].required_approving_review_count}"
  }

  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].rules[0].non_fast_forward == true
    error_message = "Repository protected_branch_base_rules rules non_fast_forward does not match. Expected: true, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].rules[0].non_fast_forward}"
  }
  # Test conditions
  assert {
    condition     = length(github_repository_ruleset.protected_branch_base_rules[0].conditions[0].ref_name[0].exclude) == 0
    error_message = "Repository protected_branch_base_rules conditions ref_name.exclude length does not match. Expected: 0, Actual: ${length(github_repository_ruleset.protected_branch_base_rules[0].conditions[0].ref_name[0].exclude)}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].conditions[0].ref_name[0].include[0] == "refs/heads/${var.protected_branches[1]}"
    error_message = "Repository protected_branch_base_rules conditions ref_name.include does not match. Expected: refs/heads/${var.protected_branches[1]}, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].conditions[0].ref_name[0].include[0]}"
  }
  assert {
    condition     = github_repository_ruleset.protected_branch_base_rules[0].conditions[0].ref_name[0].include[1] == "refs/heads/${var.protected_branches[0]}"
    error_message = "Repository protected_branch_base_rules conditions ref_name.include does not match. Expected: refs/heads/${var.protected_branches[0]}, Actual: ${github_repository_ruleset.protected_branch_base_rules[0].conditions[0].ref_name[0].include[1]}"
  }
}
