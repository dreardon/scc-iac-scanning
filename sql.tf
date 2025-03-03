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