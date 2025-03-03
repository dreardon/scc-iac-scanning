resource "google_bigquery_dataset" "public" {
  dataset_id    = "public"
  project       = var.PROJECT_ID
  friendly_name = "test"
  description   = "This dataset is public"
  # location                    = "EU"
  default_table_expiration_ms = 3600000

  access {
    role       = "READER"
    iam_member = "allUsers"
  }
  access {
    role          = "OWNER"
    user_by_email = var.BQ_OWNER
  }
}