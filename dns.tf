resource "google_dns_managed_zone" "example-zone" {
  name        = "example-zone"
  dns_name    = "example-${random_id.rnd.hex}.com."
  description = "Example DNS zone"
  dnssec_config {
    default_key_specs {
      algorithm  = "rsasha1"
      key_type   = "zoneSigning"
      key_length = "2048"
    }
  }
}

resource "random_id" "rnd" {
  byte_length = 4
}

