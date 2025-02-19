``terraform
variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy the VM"
  type        = string
}

variable "zone" {
  description = "The zone to deploy the VM"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the VM"
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_image" {
  description = "The boot disk image to use"
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Type of boot disk"
  type        = string
  default     = "pd-standard"
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

variable "additional_network_tags" {
  description = "Additional network tags to apply to the VM"
  type        = list(string)
  default     = []
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

variable "automatic_restart" {
  description = "Whether to automatically restart the VM"
  type        = bool
  default     = true
}

variable "on_host_maintenance" {
  description = "VM behavior when host is under maintenance"
  type        = string
  default     = "MIGRATE"
}

variable "install_lamp" {
  description = "Whether to install LAMP stack on the VM"
  type        = bool
  default     = true
}

variable "startup_script" {
  description = "Custom startup script if not using the built-in LAMP installation"
  type        = string
  default     = ""
}

variable "additional_metadata" {
  description = "Additional metadata to attach to the VM"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to apply to the VM"
  type        = map(string)
  default     = {}
}
```