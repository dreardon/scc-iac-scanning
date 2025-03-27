# Project creation
resource "google_project" "my_project-in-a-folder" {
  name       = "My Project"
  project_id = "your-project-id"
  org_id  = var.ORGANIZATION_ID
  auto_create_network = true
}

# VPC creation
resource "google_compute_network" "test_vpc" {
  project                 = var.PROJECT_ID
  name                    = "vpc-test-posture"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

# Subnet creation
resource "google_compute_subnetwork" "test_subnet" {
  name          = "snet-test-posture"
  project       = var.PROJECT_ID
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-east4"
  private_ip_google_access = false     
  network       = google_compute_network.test_vpc.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5 
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Firewall rule
resource "google_compute_firewall" "test_fwr" {
  name    = "test-firewall"
  network = google_compute_network.test_vpc.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}

# Load Balancer
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend_service.id
}

resource "google_compute_backend_service" "backend_service" {
  name          = "backend-service"
  protocol      = "HTTP"
  port_name     = "http"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.health_check.id]

  backend {
    group = google_compute_instance_group_manager.instance_group.instance_group
  }

  log_config {
    enable = false # Disable logging
    # sample_rate = 1.0
  }
}

resource "google_compute_health_check" "health_check" {
  name               = "health-check"
  http_health_check {
    port = 80
  }
}

resource "google_compute_instance_group_manager" "instance_group" {
  name               = "instance-group"
  zone               = "us-central1-a"
  version {
    name  = "v1"
    instance_template = google_compute_instance_template.instance_template.id
  }
  base_instance_name = "vm"
  target_size        = 1
}

resource "google_compute_instance_template" "instance_template" {
  name         = "instance-template"
  machine_type = "e2-micro"
  network_interface {
    network = "default"
  }
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
}