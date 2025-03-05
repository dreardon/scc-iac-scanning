resource "google_service_account" "scc-iac-service_account" {
  account_id   = "scc-iac-sa-validation"
  display_name = "SCC IaC Service Account Validation"
  project = var.PROJECT_ID
}

#OVER_PRIVILEGED_SERVICE_ACCOUNT_USER
resource "google_project_iam_member" "service_account_tokencreator" {
  project = var.PROJECT_ID
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.scc-iac-service_account.email}"
}

#PRIMITIVE_ROLES_USED
resource "google_project_iam_member" "service_account_owner" {
  project = var.PROJECT_ID
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.scc-iac-service_account.email}"
}

#USER_MANAGED_SERVICE_ACCOUNT_KEY
resource "google_service_account_key" "scc-iac-service_account-key" {
  service_account_id = google_service_account.scc-iac-service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

#REDIS_ROLE_USED_ON_ORG
resource "google_organization_iam_member" "service_account_redis" {
  org_id = var.ORGANIZATION_ID
  role    = "roles/redis.viewer"
  member  = "serviceAccount:${google_service_account.scc-iac-service_account.email}"
}
