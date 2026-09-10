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
  default = "custome-vpc-ai"
}
variable "subnet_name" {
  type = string
}
variable "subnet_cidr" {
  type = string
}
variable "psc_enabled" {
  type    = bool
  default = true
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
variable "preferred_backup_start_time" {
  type    = string
  default = "02:00"
  validation {
    condition     = can(regex("^([01][0-9]|2[0-3]):00$", var.preferred_backup_start_time))
    error_message = "preferred_backup_start_time must be an hour-aligned 24-hour time such as 09:00."
  }
}
variable "backup_window_seconds" {
  type    = number
  default = 3600
}
variable "preferred_maintenance_day" {
  type    = string
  default = "SUNDAY"
}
variable "preferred_maintenance_start_time" {
  type    = string
  default = "20:30"
  validation {
    condition     = can(regex("^([01][0-9]|2[0-3]):[0-5][0-9]$", var.preferred_maintenance_start_time))
    error_message = "preferred_maintenance_start_time must use 24-hour HH:MM format."
  }
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
