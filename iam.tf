resource "google_service_account" "scc-iac-service_account" {
  account_id   = "scc-iac-sa-validation"
  display_name = "SCC IaC Service Account Validation"
  project = var.PROJECT_ID
}

resource "google_project_iam_member" "service_account_user_sa" {
  project = var.PROJECT_ID
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.scc-iac-service_account.email}"
}