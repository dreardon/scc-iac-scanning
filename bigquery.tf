resource "google_bigquery_dataset" "public" {
  dataset_id    = "public"
  project       = var.PROJECT_ID
  friendly_name = "test"
  description   = "This dataset is public"
  default_table_expiration_ms = 3600000

  default_encryption_configuration {
    kms_key_name = ""
  }

  access {
    role          = "OWNER"
    user_by_email = var.BQ_OWNER
  }

  access {
    role          = "READER"
    special_group = "allAuthenticatedUsers"
  }

  access {
    role = "READER"
    iam_member = "allUsers"
  }

}

resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.public.dataset_id
  table_id   = "bar"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "permalink",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The Permalink"
  },
  {
    "name": "state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State where the head office is located"
  }
]
EOF
}