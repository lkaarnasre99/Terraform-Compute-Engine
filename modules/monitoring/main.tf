
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


### File: modules/monitoring/uptime_alert.tf

# Uptime check for HTTP availability of the LAMP VM
resource "google_monitoring_uptime_check_config" "lamp_uptime" {
  display_name = "Lamp Uptime Check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path           = "/"
    port           = "80"
    request_method = "GET"
    validate_ssl   = false
  }

 monitored_resource {
    type = "uptime_url"
    labels = {
      host       = var.instance_nat_ip
      project_id = var.project_id
    }
  }
}

# Alert policy for uptime check failures
resource "google_monitoring_alert_policy" "uptime_alert" {
  display_name = "${var.instance_name}-uptime-alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Uptime check failed"
    condition_monitoring_query_language {
      query = <<-EOT
        fetch uptime_url
        | filter metric.resource.instance_id == '${var.instance_id}'
        | filter metric.check_id == '${google_monitoring_uptime_check_config.lamp_uptime.uptime_check_id}'
        | filter metric.type == 'monitoring.googleapis.com/uptime_check/check_passed'
        | align next_older(1m)
        | every 1m
        | group_by [resource.instance_id], [value_check_passed: count_true(value.check_passed)]
        | condition val() < 1
      EOT
      duration = "60s"
      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels
  
  documentation {
    content   = "The LAMP VM (${var.instance_name}) is not responding to HTTP requests."
    mime_type = "text/markdown"
  }

  alert_strategy {
    auto_close = "1800s"  # Auto-close after 30 minutes if condition clears
  }
}

# Network traffic alert policy
resource "google_monitoring_alert_policy" "network_traffic_alert" {
  display_name = "${var.instance_name}-network-traffic-alert"
  combiner     = "OR"
  
  conditions {
    display_name = "High network traffic"
    condition_threshold {
      filter     = "metric.type=\"agent.googleapis.com/interface/traffic\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\" AND metric.label.direction=\"received\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = var.network_threshold
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = var.notification_channels
  
  documentation {
    content   = "High inbound network traffic (>${var.network_threshold} bytes/s) detected on ${var.instance_name}."
    mime_type = "text/markdown"
  }
}

### File: modules/monitoring/dashboard.tf

resource "google_monitoring_dashboard" "lamp_dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "${var.instance_name} LAMP Server Dashboard",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "CPU Utilization",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_MEAN",
                      "alignmentPeriod": "60s"
                    }
                  },
                  "unitOverride": "1"
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "label": "CPU Utilization",
              "scale": "LINEAR"
            },
            "thresholds": [
              {
                "value": ${var.cpu_threshold},
                "label": "Alert Threshold",
                "targetAxis": "Y1",
                "color": "RED"
              }
            ]
          }
        }
      },
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Memory Usage",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"agent.googleapis.com/memory/percent_used\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_MEAN",
                      "alignmentPeriod": "60s"
                    }
                  },
                  "unitOverride": "1"
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1"
              }
            ],
            "yAxis": {
              "label": "Memory Utilization",
              "scale": "LINEAR"
            },
            "thresholds": [
              {
                "value": ${var.memory_threshold},
                "label": "Alert Threshold",
                "targetAxis": "Y1",
                "color": "RED"
              }
            ]
          }
        }
      },
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Network Traffic",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"agent.googleapis.com/interface/traffic\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\" AND metric.label.direction=\"received\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_RATE",
                      "alignmentPeriod": "60s"
                    }
                  },
                  "unitOverride": "By/s"
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1",
                "legendTemplate": "Received"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"agent.googleapis.com/interface/traffic\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\" AND metric.label.direction=\"sent\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_RATE",
                      "alignmentPeriod": "60s"
                    }
                  },
                  "unitOverride": "By/s"
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1",
                "legendTemplate": "Sent"
              }
            ],
            "yAxis": {
              "label": "Network Traffic (bytes/sec)",
              "scale": "LINEAR"
            },
            "thresholds": [
              {
                "value": ${var.network_threshold},
                "label": "Alert Threshold",
                "targetAxis": "Y1",
                "color": "RED"
              }
            ]
          }
        }
      },
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Disk I/O",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"agent.googleapis.com/disk/io_time\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_RATE",
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "yAxis": {
              "label": "I/O Utilization",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "width": 12,
        "height": 3,
        "widget": {
          "title": "Uptime Check Status",
          "timeSeriesTable": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.lamp_uptime.uptime_check_id}\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_FRACTION_TRUE",
                      "alignmentPeriod": "60s"
                    },
                    "secondaryAggregation": {
                      "perSeriesAligner": "ALIGN_MEAN",
                      "alignmentPeriod": "300s"
                    }
                  }
                },
                "tableTemplate": "uptime_check_status"
              }
            ],
            "columnSettings": [
              {
                "column": "value.check_passed",
                "displayName": "Status"
              },
              {
                "column": "metric.label.checker_location",
                "displayName": "Location"
              }
            ]
          }
        }
      },
      {
        "width": 12,
        "height": 4,
        "widget": {
          "title": "Apache HTTP Server - Request Count",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"agent.googleapis.com/apache/http/request_count\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_RATE",
                      "alignmentPeriod": "60s"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "yAxis": {
              "label": "Requests/second",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "width": 12,
        "height": 3,
        "widget": {
          "title": "Recent Alerts",
          "alertChart": {
            "name": "projects/${var.project_id}/alertPolicies/*"
          }
        }
      }
    ]
  }
}
EOF
}