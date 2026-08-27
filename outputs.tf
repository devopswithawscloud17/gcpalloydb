output "network_id" {
  value = module.network.network_id
}
output "primary_cluster_id" {
  value = module.alloydb.primary_cluster_id
}
output "primary_instance_name" {
  value = module.alloydb.primary_instance_name
}
output "primary_instance_ip" {
  value = module.alloydb.primary_instance_ip
}
output "read_pool_instance_name" {
  value = module.alloydb.read_pool_instance_name
}
output "read_pool_instance_ip" {
  value = module.alloydb.read_pool_instance_ip
}
output "dr_cluster_id" {
  value = module.alloydb.dr_cluster_id
}
output "dr_instance_name" {
  value = module.alloydb.dr_instance_name
}
