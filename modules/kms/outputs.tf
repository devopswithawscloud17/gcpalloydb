output "primary_key_id" {
  value = google_kms_crypto_key.primary.id
}
output "dr_key_id" {
  value = try(google_kms_crypto_key.dr[0].id, null)
}
