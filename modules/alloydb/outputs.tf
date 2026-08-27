output "primary_cluster_id" {
  value = google_alloydb_cluster.primary.cluster_id
}

output "primary_instance_name" {
  value = google_alloydb_instance.primary.name
}

output "primary_instance_ip" {
  value = google_alloydb_instance.primary.ip_address
}

output "read_pool_instance_name" {
  value = google_alloydb_instance.read_pool.name
}

output "read_pool_instance_ip" {
  value = google_alloydb_instance.read_pool.ip_address
}

output "dr_cluster_id" {
  value = try(google_alloydb_cluster.dr[0].cluster_id, null)
}

output "dr_instance_name" {
  value = try(google_alloydb_instance.dr[0].name, null)
}



