output "network_id" {
  value = google_compute_network.this.id
}
output "service_networking_connection" {
  value = google_service_networking_connection.private_vpc_connection.id
}
