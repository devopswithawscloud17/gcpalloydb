resource "google_kms_key_ring" "primary" {
  project  = var.project_id
  name     = "${var.name_prefix}-primary-keyring8"
  location = var.primary_region
}
resource "google_kms_crypto_key" "primary" {
  name            = "${var.name_prefix}-primary-key"
  key_ring        = google_kms_key_ring.primary.id
  rotation_period = "7776000s"
}
resource "google_kms_key_ring" "dr" {
  count    = var.enable_dr ? 1 : 0
  project  = var.project_id
  name     = "${var.name_prefix}-dr-keyring3"
  location = var.dr_region
}
resource "google_kms_crypto_key" "dr" {
  count           = var.enable_dr ? 1 : 0
  name            = "${var.name_prefix}-dr-key"
  key_ring        = google_kms_key_ring.dr[0].id
  rotation_period = "7776000s"
}
data "google_project" "current" {
  project_id = var.project_id
}
resource "google_kms_crypto_key_iam_member" "primary_alloydb" {
  crypto_key_id = google_kms_crypto_key.primary.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-alloydb.iam.gserviceaccount.com"
}
resource "google_kms_crypto_key_iam_member" "dr_alloydb" {
  count         = var.enable_dr ? 1 : 0
  crypto_key_id = google_kms_crypto_key.dr[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-alloydb.iam.gserviceaccount.com"
}
