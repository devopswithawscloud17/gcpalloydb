resource "random_password" "db_password" {
  length  = 24
  special = true
}

locals {
  preferred_backup_time      = split(":", var.preferred_backup_start_time)
  preferred_maintenance_time = split(":", var.preferred_maintenance_start_time)
}

resource "google_alloydb_cluster" "primary" {
  project             = var.project_id
  cluster_id          = var.primary_cluster_id
  location            = var.primary_region
  database_version    = var.database_version
  deletion_protection = var.enable_deletion_protection
  labels              = var.labels

  maintenance_update_policy {
    maintenance_windows {
      day = var.preferred_maintenance_day

      start_time {
        hours   = tonumber(local.preferred_maintenance_time[0])
        minutes = tonumber(local.preferred_maintenance_time[1])
        seconds = 0
        nanos   = 0
      }
    }
  }

  dynamic "initial_user" {
    for_each = var.initial_user == null || local.final_password == null ? [] : [1]
    content {
      user     = var.initial_user
      password = local.final_password
    }
  }

  dynamic "network_config" {
    for_each = var.psc_enabled ? [] : [1]
    content {
      network = var.network_id
    }
  }

  psc_config {
    psc_enabled = var.psc_enabled
  }

  dynamic "encryption_config" {
    for_each = var.primary_kms_key_name == null ? [] : [1]
    content { kms_key_name = var.primary_kms_key_name }
  }

  continuous_backup_config {
    enabled              = true
    recovery_window_days = var.continuous_backup_recovery_window_days
    dynamic "encryption_config" {
      for_each = var.primary_kms_key_name == null ? [] : [1]
      content {
        kms_key_name = var.primary_kms_key_name
      }
    }
  }

  automated_backup_policy {
    enabled       = true
    location      = var.primary_region
    backup_window = "${var.backup_window_seconds}s"
    time_based_retention {
      retention_period = "${var.automated_backup_retention_count * 86400}s"
    }
    weekly_schedule {
      days_of_week = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
      start_times {
        hours   = tonumber(local.preferred_backup_time[0])
        minutes = tonumber(local.preferred_backup_time[1])
        seconds = 0
        nanos   = 0
      }
    }
    dynamic "encryption_config" {
      for_each = var.primary_kms_key_name == null ? [] : [1]
      content {
        kms_key_name = var.primary_kms_key_name
      }
    }
    labels = var.labels
  }

}

resource "google_alloydb_instance" "primary" {
  cluster           = google_alloydb_cluster.primary.name
  instance_id       = var.primary_instance_id
  instance_type     = "PRIMARY"
  availability_type = "REGIONAL"
  machine_config {
    machine_type = var.primary_machine_type
    cpu_count    = var.primary_cpu_count
  }
  database_flags = {
    "alloydb.enable_pgaudit" = "on"
    "pgaudit.log"            = "ddl,role,write"
    "log_connections"        = "on"
    "log_disconnections"     = "on"
    "log_lock_waits"         = "on"
  }
  labels = var.labels
}

resource "google_alloydb_instance" "read_pool" {
  cluster       = google_alloydb_cluster.primary.name
  instance_id   = var.read_pool_instance_id
  instance_type = "READ_POOL"
  read_pool_config {
    node_count = var.read_pool_node_count
  }
  machine_config {
    machine_type = var.read_pool_machine_type
    cpu_count    = var.read_pool_cpu_count
  }
  labels     = var.labels
  depends_on = [google_alloydb_instance.primary]

  lifecycle {
    ignore_changes = [read_pool_config[0].node_count]
  }
}

resource "google_alloydb_cluster" "dr" {
  count               = var.enable_dr ? 1 : 0
  project             = var.project_id
  cluster_id          = var.dr_cluster_id
  location            = var.dr_region
  cluster_type        = "SECONDARY"
  deletion_protection = var.enable_deletion_protection
  deletion_policy     = "FORCE"
  labels              = var.labels
  network_config {
    network = var.network_id
  }
  secondary_config {
    primary_cluster_name = google_alloydb_cluster.primary.name
  }
  automated_backup_policy {
    enabled       = true
    location      = var.dr_region
    backup_window = "${var.backup_window_seconds}s"
    time_based_retention {
      retention_period = "${var.automated_backup_retention_count * 86400}s"
    }
    weekly_schedule {
      days_of_week = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
      start_times {
        hours   = tonumber(local.preferred_backup_time[0])
        minutes = tonumber(local.preferred_backup_time[1])
        seconds = 0
        nanos   = 0
      }
    }
    dynamic "encryption_config" {
      for_each = var.dr_kms_key_name == null ? [] : [1]
      content {
        kms_key_name = var.dr_kms_key_name
      }
    }
    labels = var.labels
  }
  continuous_backup_config {
    enabled              = true
    recovery_window_days = var.continuous_backup_recovery_window_days
    dynamic "encryption_config" {
      for_each = var.dr_kms_key_name == null ? [] : [1]
      content {
        kms_key_name = var.dr_kms_key_name
      }
    }
  }
  dynamic "encryption_config" {
    for_each = var.dr_kms_key_name == null ? [] : [1]
    content {
      kms_key_name = var.dr_kms_key_name
    }
  }
}

resource "google_alloydb_instance" "dr" {
  count             = var.enable_dr ? 1 : 0
  cluster           = google_alloydb_cluster.dr[0].name
  instance_id       = var.dr_instance_id
  instance_type     = "SECONDARY"
  availability_type = "REGIONAL"
  machine_config {
    machine_type = var.dr_machine_type
    cpu_count    = var.dr_cpu_count
  }
  labels = var.labels
}
