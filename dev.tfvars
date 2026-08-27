project_id                             = "project-dba-48524"
environment                            = "dev"
primary_region                         = "asia-south1"
dr_region                              = "asia-south2"
primary_cpu_count                      = 2
read_pool_cpu_count                    = 2
read_pool_node_count                   = 1
dr_cpu_count                           = 2
database_version                       = "POSTGRES_16"
continuous_backup_recovery_window_days = 7
automated_backup_retention_count       = 7
enable_cmek                            = true
enable_dr                              = false
enable_deletion_protection             = false
notification_email                     = "alloydb-operations@example.com"
labels = {
  application         = "replace-me"
  owner               = "platform-team"
  cost_center         = "replace-me"
  data_classification = "confidential"
}


