
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

terraform {
  backend "gcs" {
  }
}

module "lamp_vm" {
  source          = "./modules/compute"
  instance_name   = var.instance_name
  project_id      = var.project_id
  region          = var.region
  zone            = var.zone
  machine_type    = var.machine_type
  boot_disk_image = var.boot_disk_image
  install_lamp    = var.install_lamp
  
  network    = var.network
  subnetwork = var.subnetwork
  
  create_firewall_rules  = var.create_firewall_rules
  additional_network_tags = var.additional_network_tags
  
  service_account_email  = var.service_account_email
  service_account_scopes = var.service_account_scopes
  
  labels    = var.labels
  ssh_user  = var.ssh_user
  ssh_pub_key_file = var.ssh_pub_key_file
}

module "monitoring" {
  source = "./modules/monitoring"
  count  = var.enable_monitoring ? 1 : 0
  
  instance_name = module.lamp_vm.instance_name
  instance_id   = module.lamp_vm.instance_id
  project_id    = var.project_id
  zone          = var.zone
  
  cpu_threshold    = var.cpu_alert_threshold
  memory_threshold = var.memory_alert_threshold
  network_threshold = var.network_alert_threshold
  
  notification_channels = var.notification_channels
}
