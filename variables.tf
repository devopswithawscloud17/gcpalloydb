variable "project_id" {
  type = string
}
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "environment must be dev, qa, or prod."
  }
}
variable "primary_region" {
  type = string
}
variable "dr_region" {
  type = string
}
variable "network_name" {
  type    = string
  default = "alloydb-vpc"
}
variable "primary_cluster_id" {
  type    = string
  default = "alloydb-primary"
}
variable "dr_cluster_id" {
  type    = string
  default = "alloydb-dr"
}
variable "primary_instance_id" {
  type    = string
  default = "alloydb-primary-instance"
}
variable "read_pool_instance_id" {
  type    = string
  default = "alloydb-read-pool"
}
variable "dr_instance_id" {
  type    = string
  default = "alloydb-dr-instance"
}
variable "primary_cpu_count" {
  type    = number
  default = 4
}
variable "primary_machine_type" {
  type    = string
  default = "n2-highmem-4"
}
variable "read_pool_cpu_count" {
  type    = number
  default = 4
}
variable "read_pool_machine_type" {
  type    = string
  default = "n2-highmem-4"
}
variable "read_pool_node_count" {
  type    = number
  default = 2
}
variable "dr_cpu_count" {
  type    = number
  default = 4
}
variable "dr_machine_type" {
  type    = string
  default = "n2-highmem-4"
}
variable "database_version" {
  type    = string
  default = "POSTGRES_16"
}
variable "initial_user" {
  type     = string
  default  = null
  nullable = true
}
variable "initial_password" {
  type      = string
  sensitive = true
  default   = null
  nullable  = true
}
variable "continuous_backup_recovery_window_days" {
  type    = number
  default = 14
  validation {
    condition     = var.continuous_backup_recovery_window_days >= 1 && var.continuous_backup_recovery_window_days <= 35
    error_message = "Recovery window must be 1-35 days."
  }
}
variable "automated_backup_retention_count" {
  type    = number
  default = 14
}
variable "backup_start_hour" {
  type    = number
  default = 2
}
variable "enable_cmek" {
  type    = bool
  default = true
}
variable "enable_dr" {
  type    = bool
  default = true
}
variable "enable_deletion_protection" {
  type    = bool
  default = true
}
variable "notification_email" {
  type     = string
  default  = null
  nullable = true
}
variable "labels" {
  type    = map(string)
  default = {}
}
