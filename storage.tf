resource "google_storage_bucket" "example_bucket" {
  name          = "example-bucket-1dsjafkldsaf"
  location      = "EU"
  force_destroy = true

  project = var.PROJECT_ID

  uniform_bucket_level_access = true
}