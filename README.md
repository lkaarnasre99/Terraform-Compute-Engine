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
