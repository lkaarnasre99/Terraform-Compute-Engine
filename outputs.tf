
output "vm_name" {
  description = "The name of the VM instance"
  value       = module.lamp_vm.instance_name
}

output "vm_public_ip" {
  description = "The public IP address of the VM instance"
  value       = module.lamp_vm.instance_nat_ip
}

output "vm_private_ip" {
  description = "The private IP address of the VM instance"
  value       = module.lamp_vm.instance_private_ip
}

output "vm_self_link" {
  description = "The self link of the VM instance"
  value       = module.lamp_vm.self_link
}

output "cpu_alert_policy_id" {
  description = "The ID of the CPU alert policy"
  value       = var.enable_monitoring ? module.monitoring[0].cpu_alert_policy_id : null
}

output "memory_alert_policy_id" {
  description = "The ID of the memory alert policy"
  value       = var.enable_monitoring ? module.monitoring[0].memory_alert_policy_id : null
}

output "dashboard_id" {
  description = "The ID of the VM dashboard"
  value       = var.enable_monitoring ? module.monitoring[0].dashboard_id : null
}

output "uptime_check_id" {
  description = "The ID of the uptime check"
  value       = var.enable_monitoring ? module.monitoring[0].uptime_check_id : null
}

output "uptime_alert_policy_id" {
  description = "The ID of the uptime alert policy"
  value       = var.enable_monitoring ? module.monitoring[0].uptime_alert_policy_id : null
}

output "network_alert_policy_id" {
  description = "The ID of the network traffic alert policy"
  value       = var.enable_monitoring ? module.monitoring[0].network_alert_policy_id : null
}