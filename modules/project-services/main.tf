variable "project_id" {
  type = string
}
locals {
  services = toset([
    "alloydb.googleapis.com", "compute.googleapis.com",
    "cloudkms.googleapis.com", "monitoring.googleapis.com", "logging.googleapis.com",
    "iamcredentials.googleapis.com", "sts.googleapis.com"
  ])
}
resource "google_project_service" "enabled" {
  for_each           = local.services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
