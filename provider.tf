terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  region  = var.REGION
  zone    = var.ZONE
  project = var.PROJECT_ID
}