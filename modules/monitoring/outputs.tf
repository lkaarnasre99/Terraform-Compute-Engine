
output "cpu_alert_policy_id" {
  description = "The ID of the CPU alert policy"
  value       = google_monitoring_alert_policy.cpu_usage.id
}

output "memory_alert_policy_id" {
  description = "The ID of the memory alert policy"
  value       = google_monitoring_alert_policy.memory_usage.id
}

output "dashboard_id" {
  description = "The ID of the VM dashboard"
  value       = google_monitoring_dashboard.vm_dashboard.id
}

output "uptime_check_id" {
  description = "The ID of the uptime check"
  value       = google_monitoring_uptime_check_config.lamp_uptime.id
}

output "uptime_alert_policy_id" {
  description = "The ID of the uptime alert policy"
  value       = google_monitoring_alert_policy.uptime_alert.id
}

output "network_alert_policy_id" {
  description = "The ID of the network traffic alert policy"
  value       = google_monitoring_alert_policy.network_traffic_alert.id
}
