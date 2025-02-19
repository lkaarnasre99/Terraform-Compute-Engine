```terraform
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = merge(
    {
      ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
    },
    var.additional_metadata
  )

  metadata_startup_script = var.install_lamp ? file("${path.module}/scripts/install_lamp.sh") : var.startup_script

  tags = concat(["http-server"], var.additional_network_tags)

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  scheduling {
    automatic_restart   = var.automatic_restart
    on_host_maintenance = var.on_host_maintenance
  }

  allow_stopping_for_update = true
}

resource "google_compute_firewall" "http_firewall" {
  count   = var.create_firewall_rules ? 1 : 0
  name    = "${var.instance_name}-allow-http"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
```