variable "project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "network_id" {
  type = string
}

variable "primary_region" {
  type = string
}

variable "dr_region" {
  type = string
}

variable "primary_cluster_id" {
  type = string
}

variable "dr_cluster_id" {
  type = string
}

variable "primary_instance_id" {
  type = string
}

variable "read_pool_instance_id" {
  type = string
}

variable "dr_instance_id" {
  type = string
}

variable "primary_cpu_count" {
  type = number
}
variable "primary_machine_type" {
  type = string
}

variable "read_pool_cpu_count" {
  type = number
}
variable "read_pool_machine_type" {
  type = string
}

variable "read_pool_node_count" {
  type = number
}

variable "dr_cpu_count" {
  type = number
}
variable "dr_machine_type" {
  type = string
}

variable "database_version" {
  type = string
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
  type = number
}

variable "automated_backup_retention_count" {
  type = number
}

variable "preferred_backup_start_time" {
  type = string
}

variable "backup_window_seconds" {
  type = number
}

variable "preferred_maintenance_day" {
  type = string
}

variable "preferred_maintenance_start_time" {
  type = string
}

variable "psc_enabled" {
  type = bool
}

variable "primary_kms_key_name" {
  type     = string
  default  = null
  nullable = true
}

variable "dr_kms_key_name" {
  type     = string
  default  = null
  nullable = true
}

variable "enable_dr" {
  type = bool
}

variable "enable_deletion_protection" {
  type = bool
}

variable "labels" {
  type = map(string)
}

locals {
  final_password = coalesce(var.initial_password, random_password.db_password.result)
}
