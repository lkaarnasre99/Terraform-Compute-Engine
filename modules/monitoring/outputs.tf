```terraform
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
```