resource "google_monitoring_notification_channel" "email" {
  count        = var.notification_email == null ? 0 : 1
  project      = var.project_id
  display_name = "${var.name_prefix} operations email"
  type         = "email"
  labels       = { email_address = var.notification_email }
}

resource "google_monitoring_alert_policy" "cpu" {
  project      = var.project_id
  display_name = "${var.name_prefix} AlloyDB high CPU"
  combiner     = "OR"
  conditions {
    display_name = "AlloyDB CPU > 80% for 5 minutes"
    condition_threshold {
      filter          = "resource.type = \"alloydb.googleapis.com/Instance\" AND metric.type = \"alloydb.googleapis.com/instance/cpu/maximum_utilization\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.80
      duration        = "300s"
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MAX"
      }
      trigger {
        count = 1
      }
    }
  }
  notification_channels = var.notification_email == null ? [] : [google_monitoring_notification_channel.email[0].name]
  user_labels = merge(var.labels, {
    severity = "warning"
  })
}

resource "google_logging_project_sink" "alloydb_audit" {
  project                = var.project_id
  name                   = "${var.name_prefix}-alloydb-audit"
  destination            = "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/_Default"
  filter                 = "protoPayload.serviceName=\"alloydb.googleapis.com\""
  unique_writer_identity = true
}
