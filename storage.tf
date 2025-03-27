resource "google_storage_bucket" "scc-iac-example_bucket" {
  name          = "example-bucket-1dsjafkldsaf"
  location      = "US"
  force_destroy = true

  project = var.PROJECT_ID

}

#TODO Trigger PUBLIC_BUCKET_ACL Finding
# resource "google_storage_bucket_iam_binding" "binding" {
#   bucket = google_storage_bucket.scc-iac-example_bucket.name
#   role = "roles/storage.objectViewer"
#   members = [
#     "allUsers",
#   ]
# }

# Create bucket
resource "google_storage_bucket" "sample" {
  name          = "example-bucket"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = false
}