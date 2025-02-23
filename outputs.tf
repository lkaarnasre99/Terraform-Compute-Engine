
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


