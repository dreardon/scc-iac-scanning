resource "google_sql_database_instance" "main" {
  name                = "main-instance"
  project             = var.PROJECT_ID
  database_version    = "POSTGRES_15"
  region              = var.REGION
  deletion_protection = false

settings {
    tier = "db-f1-micro" # Replace with your desired tier

    # Enable automatic backups
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }


    # Disable public IP (recommended for security)
    ip_configuration {
      ipv4_enabled = true
      ssl_mode = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }

    # Enable logging (adjust flags as needed)
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }
    database_flags {
      name  = "log_connections"
      value = "on"
    }
    database_flags {
      name  = "log_disconnections"
      value = "on"
    }
    database_flags {
        name = "log_duration"
        value = "on"
    }
    database_flags {
        name = "log_error_verbosity"
        value = "verbose"
    }
    database_flags {
        name = "log_executor_stats"
        value = "on"
    }
    database_flags {
        name = "log_hostname"
        value = "on"
    }
    database_flags {
        name = "log_lock_waits"
        value = "on"
    }
    database_flags {
        name = "log_min_duration_statement"
        value = "0" # Log all statements
    }
    database_flags {
        name = "log_min_error_statement"
        value = "error"
    }
    database_flags {
        name = "log_min_error_statement_severity"
        value = "error"
    }
    database_flags {
        name = "log_min_messages"
        value = "notice"
    }
    database_flags {
        name = "log_parser_stats"
        value = "on"
    }
    database_flags {
        name = "log_planner_stats"
        value = "on"
    }
    database_flags {
        name = "log_statement"
        value = "all" # Log all statements
    }
    database_flags {
        name = "log_statement_stats"
        value = "on"
    }
    database_flags {
        name = "log_temp_files"
        value = "0" # Log all temp files
    }

    # Disable external scripts and local infile (security best practices)
    database_flags {
      name  = "allow_system_table_mods" # Necessary for external scripts
      value = "off"
    }
    database_flags {
        name = "local_infile"
        value = "off"
    }

    # Disable cross-db ownership chaining
    database_flags {
      name  = "db_chaining"
      value = "off"
    }

    # Disable contained database authentication
    database_flags {
        name = "contained_authentication"
        value = "off"
    }

    # Disable skip show database (less information disclosure)
    database_flags {
        name = "skip_show_database"
        value = "on"
    }

    # Configure user connections (example, adjust as needed)
    database_flags {
        name = "max_connections"
        value = "100" 
    }

    # Configure user options (example, adjust as needed)
    database_flags {
        name = "default_transaction_isolation"
        value = "read committed"
    }

    # Audit logging (You will need to configure Cloud Audit Logs separately)
    # This enables the flags, but the actual logging setup is outside of Cloud SQL.

    # Disable Trace Flag 3625 (SQL Server specific, not applicable to Postgres)

  }
}

# Example of creating a database within the instance
resource "google_sql_database" "postgres_db" {
  name     = "mydatabase"
  instance = google_sql_database_instance.main.name
}

# Example of creating a user
#resource "google_sql_user" "postgres_user" {
#  name     = "myuser"
#  instance = google_sql_database_instance.main.name
#  password = "mypassword" # IMPORTANT: In production, use a secret management solution!
# }

#Example CMEK for Cloud SQL

# resource "google_kms_crypto_key" "cloudsql_key" {
#   name                = "cloudsql-key"
#   key_ring            = google_kms_key_ring.keyring.id # Assuming you have key ring already created
#   rotation_period     = "2592000s"
# }

# resource "google_kms_key_ring" "keyring" {
#   name     = "cloudsql-keyring"
#   location = "us-central1"
# }

# resource "google_sql_database_instance" "postgres_instance_cmek" {
#   name             = "postgres-instance-cmek"
#   region           = "us-central1" # Replace with your desired region
#   database_version = "POSTGRES_15"

#   settings {
#     tier = "db-f1-micro" # Replace with your desired tier
#         disk_encryption_configuration {
#           kms_key_name = google_kms_crypto_key.cloudsql_key.id
#         }
#   }
# }