# Terraform-Compute-Engine
Reusable Terraform Module for GCP LAMP VM

## Directory Structure
```
terraform-gcp-lamp/
├── modules/
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── scripts/
│   │       └── install_lamp.sh
│   ├── monitoring/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
└── versions.tf
```
Key Features of the Module:

Fully Parameterized Design:

Everything is configurable through variables
Sensible defaults provided for common settings
Example terraform.tfvars file included


Modular Architecture:

Separate compute module for VM creation
Dedicated monitoring module that can be enabled/disabled
Easy to extend with additional modules


LAMP Stack Configuration:

Debian 12 (bookworm) as requested
Apache2 and PHP installation via startup script
HTTP firewall rule creation


Monitoring Capabilities:

CPU and memory usage alerts
Custom dashboard creation
Configurable thresholds and notification channels


How to Use the Module:

Create the directory structure as outlined
Place all files in their respective locations
Create a terraform.tfvars file based on the example
Run terraform init and terraform apply