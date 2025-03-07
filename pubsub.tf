resource "google_project_service" "pubsub-api" {
  service                    = "pubsub.googleapis.com"
  disable_dependent_services = true
}

resource "google_pubsub_topic" "example" {
  depends_on = [google_project_service.pubsub-api]
  name       = "example-topic"

  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}
