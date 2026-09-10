data "google_compute_network" "this" {
  project = var.project_id
  name    = var.network_name
}

data "google_compute_subnetwork" "this" {
  project = var.project_id
  region  = var.region
  name    = var.subnet_name
}

check "subnet_cidr_matches" {
  assert {
    condition     = data.google_compute_subnetwork.this.ip_cidr_range == var.subnet_cidr
    error_message = "The existing subnet ${var.subnet_name} does not use CIDR ${var.subnet_cidr}."
  }
}

