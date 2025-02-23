
output "uptime_check_id" {
  description = "The ID of the uptime check"
  value       = google_monitoring_uptime_check_config.lamp_uptime_check.id
}

output "qwik_start_dashboard_id" {
  description = "The ID of the LAMP Qwik Start dashboard"
  value       = google_monitoring_dashboard.lamp_qwik_start_dashboard.id
}



