resource "google_compute_network" "example_network" {
  name                            = "default"
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 100
  project                         = var.PROJECT_ID
}