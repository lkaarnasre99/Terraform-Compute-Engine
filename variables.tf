
# Project variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "zone" {
  description = "The zone to deploy resources"
  type        = string
}

# VM variables
variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the VM"
  type        = string
}

variable "boot_disk_image" {
  description = "The boot disk image to use"
  type        = string
}

variable "network" {
  description = "The network to attach the VM to"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to attach the VM to"
  type        = string
  default     = "default"
}

variable "create_firewall_rules" {
  description = "Whether to create firewall rules"
  type        = bool
  default     = true
}

variable "additional_network_tags" {
  description = "Additional network tags to apply to the VM"
  type        = list(string)

}

variable "service_account_email" {
  description = "Service account email"
  type        = string
  default     = ""
}

variable "service_account_scopes" {
  description = "Service account scopes"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "install_lamp" {
  description = "Whether to install LAMP stack on the VM"
  type        = bool
  default     = true
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "admin"
}

variable "ssh_pub_key_file" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "labels" {
  description = "Labels to apply to the VM"
  type        = map(string)
  default     = {}
}

# Monitoring variables
variable "enable_monitoring" {
  description = "Whether to enable monitoring"
  type        = bool
  default     = true
}

variable "cpu_alert_threshold" {
  description = "CPU threshold for alert (between 0 and 1)"
  type        = number
  default     = 0.8
}

variable "memory_alert_threshold" {
  description = "Memory threshold for alert (between 0 and 1)"
  type        = number
  default     = 0.8
}

variable "notification_channels" {
  description = "List of notification channel IDs"
  type        = list(string)
  default     = []
}
