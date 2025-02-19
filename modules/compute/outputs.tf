
output "instance_id" {
  description = "The ID of the VM instance"
  value       = google_compute_instance.vm_instance.id
}

output "instance_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.vm_instance.name
}

output "instance_nat_ip" {
  description = "The public IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "instance_private_ip" {
  description = "The private IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "self_link" {
  description = "The self link of the VM instance"
  value       = google_compute_instance.vm_instance.self_link
}
