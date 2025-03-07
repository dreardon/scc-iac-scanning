resource "google_project_service" "kms-api" {
  service = "cloudkms.googleapis.com"
}

resource "google_kms_key_ring" "keyring" {
  depends_on = [google_project_service.kms-api]
  name       = "keyringexample"
  location   = var.REGION
}

resource "google_kms_crypto_key" "example-key" {
  name     = "crypto-key-example"
  key_ring = "projects/${var.PROJECT_ID}/locations/${var.REGION}/keyRings/${google_kms_key_ring.keyring.name}"
}
