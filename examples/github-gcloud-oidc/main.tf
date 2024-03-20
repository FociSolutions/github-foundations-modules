module "gcp_oidc_setup" {
  source = "../../modules/github-gcloud-oidc"

  organization_id                      = "123456789012"
  folder_create                        = false
  id                                   = "123456789012"
  project_name                         = "my-oidc-project"
  billing_account                      = "ABCDEF-123456-ABCDEF"
  auto_create_network                  = false
  labels                               = { "team" = "devops" }
  services                             = ["cloudresourcemanager.googleapis.com", "iam.googleapis.com", "storage.googleapis.com"]
  bucket_name                          = "my-terraform-state-bucket"
  location                             = "europe-west3"
  storage_class                        = "STANDARD"
  uniform_bucket_level_access          = true
  github_foundations_organization_name = "my-github-org"
}
