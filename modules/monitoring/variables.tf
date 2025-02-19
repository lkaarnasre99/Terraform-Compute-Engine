
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


