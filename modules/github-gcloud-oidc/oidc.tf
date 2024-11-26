locals {
  pool_id     = "pool-oidc-github-foundation"
  provider_id = "provider-oidc-github-foundation"

  state_file_access_roles = tolist(["roles/storage.objectAdmin", "roles/storage.admin"])

  bootstrap_project_roles = local.state_file_access_roles

  organziations_project_roles = concat(
    local.state_file_access_roles,
    tolist([
      "roles/secretmanager.viewer",
      "roles/secretmanager.secretAccessor",
      "roles/iam.workloadIdentityUser"
    ])
  )
}

/**
* Service account and roles for github state bucket and oidc module setup
*/

resource "google_service_account" "bootstrap_sa" {
  project    = google_project.project[0].project_id
  account_id = "${var.bootstrap_repo_name}-sa"
}

resource "google_project_iam_member" "bootstrap_project_member" {
  for_each = toset(local.bootstrap_project_roles)
  project  = google_project.project[0].project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.bootstrap_sa.email}"
}

resource "google_service_account" "organizations_sa" {
  project    = google_project.project[0].project_id
  account_id = "${var.organizations_repo_name}-sa"
}

resource "google_project_iam_member" "organizations_member" {
  for_each = toset(local.organziations_project_roles)
  project  = google_service_account.organizations_sa.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.organizations_sa.email}"
}

/*
* oidc setup
*/
#trivy:ignore:avd-gcp-0068
module "oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version     = "4.0.0"
  depends_on  = [google_project_service.project_services, google_service_account.bootstrap_sa, google_service_account.organizations_sa]
  project_id  = google_project.project[0].project_id
  pool_id     = local.pool_id
  provider_id = local.provider_id

  sa_mapping = {
    (google_service_account.bootstrap_sa.account_id) = {
      sa_name   = google_service_account.bootstrap_sa.name
      attribute = "attribute.repository/${var.github_foundations_organization_name}/${var.bootstrap_repo_name}"
    },
    (google_service_account.organizations_sa.account_id) = {
      sa_name   = google_service_account.organizations_sa.name
      attribute = "attribute.repository/${var.github_foundations_organization_name}/${var.organizations_repo_name}"
    }
  }
}
