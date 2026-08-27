locals {
  name_prefix = "alloydb-${var.environment}"
  common_labels = merge({
    environment = var.environment
    managed_by  = "terraform"
    platform    = "alloydb"
  }, var.labels)
}

module "project_services" {
  source     = "./modules/project-services"
  project_id = var.project_id
}

module "network" {
  source       = "./modules/network"
  project_id   = var.project_id
  network_name = "${var.network_name}-${var.environment}"
  depends_on   = [module.project_services]
}

module "kms" {
  source         = "./modules/kms"
  count          = var.enable_cmek ? 1 : 0
  project_id     = var.project_id
  primary_region = var.primary_region
  dr_region      = var.dr_region
  name_prefix    = local.name_prefix
  enable_dr      = var.enable_dr
  depends_on     = [module.project_services]
}

module "alloydb" {
  source                                 = "./modules/alloydb"
  project_id                             = var.project_id
  environment                            = var.environment
  network_id                             = module.network.network_id
  primary_region                         = var.primary_region
  dr_region                              = var.dr_region
  primary_cluster_id                     = "${var.primary_cluster_id}-${var.environment}"
  dr_cluster_id                          = "${var.dr_cluster_id}-${var.environment}"
  primary_instance_id                    = "${var.primary_instance_id}-${var.environment}"
  read_pool_instance_id                  = "${var.read_pool_instance_id}-${var.environment}"
  dr_instance_id                         = "${var.dr_instance_id}-${var.environment}"
  primary_cpu_count                      = var.primary_cpu_count
  read_pool_cpu_count                    = var.read_pool_cpu_count
  read_pool_node_count                   = var.read_pool_node_count
  dr_cpu_count                           = var.dr_cpu_count
  database_version                       = var.database_version
  initial_user                           = var.initial_user
  initial_password                       = var.initial_password
  continuous_backup_recovery_window_days = var.continuous_backup_recovery_window_days
  automated_backup_retention_count       = var.automated_backup_retention_count
  backup_start_hour                      = var.backup_start_hour
  primary_kms_key_name                   = var.enable_cmek ? module.kms[0].primary_key_id : null
  dr_kms_key_name                        = var.enable_cmek && var.enable_dr ? module.kms[0].dr_key_id : null
  enable_dr                              = var.enable_dr
  enable_deletion_protection             = var.enable_deletion_protection
  labels                                 = local.common_labels
  depends_on                             = [module.network]
}

module "observability" {
  source             = "./modules/observability"
  project_id         = var.project_id
  name_prefix        = local.name_prefix
  notification_email = var.notification_email
  cluster_id         = module.alloydb.primary_cluster_id
  labels             = local.common_labels
  depends_on         = [module.alloydb]
}
