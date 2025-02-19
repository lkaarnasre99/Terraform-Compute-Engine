```terraform
# Project settings
project_id = "playground-s-11-f902f813"
region     = "us-central1"
zone       = "us-central1-a"

# VM settings
instance_name = "lamp-1-vm"
machine_type  = "e2-medium"
boot_disk_image = "debian-cloud/debian-12"
install_lamp = true

# Network settings
network    = "default"
subnetwork = "default"
create_firewall_rules = true
additional_network_tags = []

# SSH settings
ssh_user = "admin"
ssh_pub_key_file = "~/.ssh/id_rsa.pub"

# Labels
labels = {
  environment = "dev",
  app         = "lamp"
}

# Monitoring settings
enable_monitoring = true
cpu_alert_threshold = 0.8
memory_alert_threshold = 0.8
notification_channels = []
```

