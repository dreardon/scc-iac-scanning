# VM Creation
resource "google_compute_instance" "default" {
  name         = "my-instance"
  project      = var.PROJECT_ID
  machine_type = "n2d-standard-2"
  zone         = "us-east4-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  allow_stopping_for_update = true # Required for several test fields
  can_ip_forward = true

  shielded_instance_config {
    enable_secure_boot = false
    enable_integrity_monitoring = false
    enable_vtpm = false
  }

  # confidential_instance_config {
  #   enable_confidential_compute = false
  # }

  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"
    # subnetwork = google_compute_subnetwork.test_subnet.self_link

    access_config {
      // Ephemeral public IP
    }
  }

  # Defaults to the default service account if omitting email
  service_account {
    scopes = ["cloud-platform"] # FULL_API_ACCESS
  }

  metadata = {
    foo                        = "bar"
    serial-port-logging-enable = "TRUE"
    enable-oslogin             = "FALSE"
    serial-port-enable         = "TRUE"
    enforce_customer_supplied_disk_encryption_keys = "TRUE"
  }
}

# Image creation
data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_disk" "persistent" {
  name  = "example-disk"
  image = data.google_compute_image.debian.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"
}

resource "google_compute_image" "example" {
  name = "example-image"

  source_disk = google_compute_disk.persistent.id
}

# Image IAM policy 
resource "google_compute_image_iam_member" "member" {
  project = var.PROJECT_ID
  image = google_compute_image.example.name
  role = "roles/compute.imageUser"
  member = "allUsers"
}