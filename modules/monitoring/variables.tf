
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

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "zone" {
  description = "The zone where the VM instance is deployed"
  type        = string
}

variable "network_threshold" {
  description = "Network traffic threshold for alert (bytes/s)"
  type        = number
  default     = 500000  # 500KB/s
}


 variable "instance_nat_ip" {
  description = "Public IP address of the VM instance"
  type        = string
}


variable "admin_email" {
  description = "Email address for alert notifications"
  type        = string
}

# Make sure these existing variables are present
# variable "instance_name" - already exists
# variable "instance_id" - already exists
# variable "notification_channels" - already exists


