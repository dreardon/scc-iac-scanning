terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.24.0"
    }
  }
}

provider "google" {
  region  = var.REGION
  zone    = var.ZONE
  project = var.PROJECT_ID
}