resource "google_service_account" "scc-iac-staged-service_account" {
  account_id   = "scc-iac-staged-sa-validation"
  display_name = "SCC IaC Staged Service Account Validation"
  project = var.PROJECT_ID
}

resource "google_storage_bucket" "scc-iac-staged-bucket" {
  name          = "example-staged-bucket-hfgtyrh"
  location      = "US"
  force_destroy = true
  project = var.PROJECT_ID
  uniform_bucket_level_access = true
}

resource "google_kms_key_ring" "scc-iac-staged-keyring" {
  name       = "scc-iac-staged-keyring-example"
  location   = var.REGION
}

resource "google_kms_crypto_key" "scc-iac-staged-fixed-rotation-crypto-key" {
  name            = "scc-iac-staged-fixed-rotation-crypto-key"
  key_ring        = google_kms_key_ring.scc-iac-staged-keyring.id
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = true
  }
}





