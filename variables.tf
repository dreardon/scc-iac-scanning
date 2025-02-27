variable "project_id" {
  type = string
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "bq_owner" {
  type = string
}
