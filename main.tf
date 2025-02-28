
resource "google_compute_network" "example_network" {
  name                            = "default"
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 100
  project                         = var.PROJECT_ID
}

# resource "google_service_account" "default" {
#   account_id   = "my-custom-sa"
#   display_name = "Custom SA for VM Instance"
# }

resource "google_compute_instance" "default" {
  name         = "my-instance"
  project      = var.PROJECT_ID
  machine_type = "n2d-standard-2"
  zone         = var.ZONE

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  confidential_instance_config {
    enable_confidential_compute = false
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo                        = "bar"
    serial-port-logging-enable = "TRUE"
    enable-oslogin             = "FALSE"
  }


  # service_account {
  #   # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #   email  = google_service_account.default.email
  #   scopes = ["cloud-platform"]
  # }
}

resource "google_sql_database_instance" "main" {
  name                = "main-instance"
  project             = var.PROJECT_ID
  database_version    = "POSTGRES_15"
  region              = var.REGION
  deletion_protection = false

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      ssl_mode     = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }
  }
}

# resource "google_container_node_pool" "example_node_pool" {
#   name               = "example-node-pool-1"
#   cluster            = "example-cluster-1"
#   project            = var.PROJECT_ID
#   initial_node_count = 1

#   node_config {
#     preemptible  = true
#     machine_type = "e2-medium"
#   }
# }

resource "google_storage_bucket" "example_bucket" {
  name          = "example-bucket-1dsjafkldsaf"
  location      = "EU"
  force_destroy = true

  project = var.PROJECT_ID

  uniform_bucket_level_access = true
}

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
