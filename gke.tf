resource "google_project_service" "gke-api" {
  service = "container.googleapis.com"
}

# Test for OVER_PRIVILEGED_ACCOUNT
# Evaluates the config property of a node pool to check 
# if no service account is specified or if the default service account is used.

# Test for OVER_PRIVILEGED_SCOPES
# Checks whether the access scope listed in the config.oauthScopes 
# property of a node pool is a limited service account access scope: 
# https://www.googleapis.com/auth/devstorage.read_only, 
# https://www.googleapis.com/auth/logging.write, or 
# https://www.googleapis.com/auth/monitoring.

# Test for COS_NOT_USED
# Checks the config property of a node pool for the key-value pair, "imageType": "COS".

# Test for NODEPOOL_SECURE_BOOT_DISABLED


resource "google_container_cluster" "primary" {
  depends_on          = [google_project_service.gke-api]
  deletion_protection = false
  name                = "marcellus-wallace"
  location            = var.ZONE
  initial_node_count  = 3
  node_config {
    image_type = "UBUNTU_CONTAINERD"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Test for INTEGRITY_MONITORING_DISABLED

# Test for LEGACY_METADATA_ENABLED

resource "google_container_cluster" "alpha" {
  depends_on          = [google_project_service.gke-api]
  deletion_protection = false
  # enable_kubernetes_alpha = true
  logging_service       = "none"
  monitoring_service    = "none"
  name                  = "marcellus-alpha"
  location              = var.ZONE
  initial_node_count    = 3
  enable_shielded_nodes = true
  enable_legacy_abac    = true
  cluster_autoscaling {
    auto_provisioning_defaults {
      management {
        auto_upgrade = false
        auto_repair  = false
      }
    }
  }

  node_config {
    image_type = "UBUNTU_CONTAINERD"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = false
    }

    metadata = {
      "disable-legacy-endpoints" = "false"
    }

    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}
