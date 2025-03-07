resource "google_project_service" "dataproc-api" {
  service = "dataproc.googleapis.com"
}


resource "google_project_service" "rm-api" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_dataproc_cluster" "iaccluster" {
  depends_on                    = [google_project_service.dataproc-api, google_project_service.rm-api]
  name                          = "iaccluster"
  region                        = var.REGION
  graceful_decommission_timeout = "360s"

  cluster_config {

    # Override or set some custom properties
    software_config {
      image_version = "1.3.94-debian10"
    }

  }
}
