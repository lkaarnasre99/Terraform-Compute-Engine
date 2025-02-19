```terraform
resource "google_monitoring_alert_policy" "cpu_usage" {
  display_name = "${var.instance_name}-high-cpu-usage"
  combiner     = "OR"
  conditions {
    display_name = "High CPU usage"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.cpu_threshold
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels
  
  documentation {
    content   = "CPU utilization for instance ${var.instance_name} exceeds ${var.cpu_threshold * 100}%"
    mime_type = "text/markdown"
  }
}

resource "google_monitoring_alert_policy" "memory_usage" {
  display_name = "${var.instance_name}-high-memory-usage"
  combiner     = "OR"
  conditions {
    display_name = "High memory usage"
    condition_threshold {
      filter          = "metric.type=\"agent.googleapis.com/memory/percent_used\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.memory_threshold
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels
  
  documentation {
    content   = "Memory utilization for instance ${var.instance_name} exceeds ${var.memory_threshold * 100}%"
    mime_type = "text/markdown"
  }
}

resource "google_monitoring_dashboard" "vm_dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "${var.instance_name} Dashboard",
  "gridLayout": {
    "widgets": [
      {
        "title": "CPU Usage",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_MEAN",
                  "alignmentPeriod": "60s"
                }
              }
            },
            "plotType": "LINE"
          }],
          "yAxis": {
            "label": "CPU utilization",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Memory Usage",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"agent.googleapis.com/memory/percent_used\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_MEAN",
                  "alignmentPeriod": "60s"
                }
              }
            },
            "plotType": "LINE"
          }],
          "yAxis": {
            "label": "Memory utilization",
            "scale": "LINEAR"
          }
        }
      }
    ]
  }
}
EOF
}
```