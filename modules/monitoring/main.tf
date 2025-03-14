resource "google_monitoring_uptime_check_config" "lamp_uptime_check" {
  display_name = "Lamp Uptime Check test"
  timeout      = "10s"
  period       = "60s"  # 1 minute check frequency

  selected_regions = ["USA"]
  
  http_check {
    path           = "/"
    port           = "80"
    request_method = "GET"
    use_ssl = false
    validate_ssl   = false
  }
  
 /* monitored_resource {
    type = "uptime_url"
    labels = {
      host = var.nat_ip
      project = var.project_id
          }
  }*/

  monitored_resource {
    type = "gce_instance"    # Resource Type = Instance

    labels = {
      instance_id = format("projects/%s/zones/%s/instances/%s",
        var.project_id,
        var.zone,
        var.instance_name
      )
      zone = var.zone
      project_id = var.project_id
    }
  }

  content_matchers {
    matcher = "CONTAINS_STRING"
    content = "OK"
  }


}

resource "google_monitoring_alert_policy" "inbound_traffic_alert" {
  display_name = "Inbound Traffic Alert"

  combiner     = "OR"
  
  conditions {
    display_name = "Network traffic threshold"
    condition_threshold {
      filter     = "metric.type=\"agent.googleapis.com/interface/traffic\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\" AND metric.label.direction=\"received\""
      duration   = "60s"  # 1 min retest window
      comparison = "COMPARISON_GT"
      threshold_value = 500  # 500 bytes/s threshold
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
  
  documentation {
    content   = "High inbound network traffic detected on ${var.instance_name}. Network traffic has exceeded the 500 bytes/s threshold."
    mime_type = "text/markdown"
  }

  alert_strategy {
    auto_close = "1800s"  # Auto-close after 30 minutes if condition clears
  }
}


resource "google_monitoring_notification_channel" "email" {
  display_name = "Admin Email"
  type         = "email"
  labels = {
    email_address = var.admin_email
  }
}


resource "google_monitoring_dashboard" "lamp_qwik_start_dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "Cloud Monitoring LAMP Qwik Start Dashboard",
  "gridLayout": {
    "widgets": [
      {
        "title": "CPU Load (1m)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"compute.googleapis.com/instance/cpu/load_1m\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_MEAN",
                  "alignmentPeriod": "60s"
                }
              }
            },
            "plotType": "LINE"
          }],
          "yAxis": {
            "label": "CPU Load (1m)",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Received Packets",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"compute.googleapis.com/instance/network/received_packets_count\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${var.instance_id}\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_RATE",
                  "alignmentPeriod": "60s"
                }
              }
            },
            "plotType": "LINE"
          }],
          "yAxis": {
            "label": "Packets/sec",
            "scale": "LINEAR"
          }
        }
      }
    ]
  }
}
EOF

  project = var.project_id
}