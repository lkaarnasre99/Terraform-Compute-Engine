
variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
}

variable "instance_id" {
  description = "The ID of the VM instance"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU threshold for alert (between 0 and 1)"
  type        = number
  default     = 0.8
}

variable "memory_threshold" {
  description = "Memory threshold for alert (between 0 and 1)"
  type        = number
  default     = 0.8
}

variable "notification_channels" {
  description = "List of notification channel IDs"
  type        = list(string)
  default     = []
}


## Module: monitoring/outputs.tf

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
