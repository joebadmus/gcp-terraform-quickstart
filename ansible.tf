## Ansible Host machine in public subnet
# Compute
resource "google_compute_instance" "ansible_host" {
  name         = "ansible-host"
  machine_type = "f1-micro"

  tags = ["ansible-host"]

  boot_disk {
    initialize_params {
      image = "centos-7-v20210721"
    }
  }

  metadata_startup_script = <<EOT
    sudo yum -y epel-release
    sudo yum -y install ansible
EOT

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.quickstart_public_subnet.self_link
    access_config {
      network_tier = "STANDARD"
    }
  }

  # service_account {
  #   # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #   email  = google_service_account.default.email
  #   scopes = ["cloud-platform"]
  # }

  depends_on = [
    google_compute_subnetwork.quickstart_public_subnet
  ]
}


# Firewall
resource "google_compute_firewall" "allow_ssh_to_ansible_controller" {
  name    = "allow-ssh-to-pub-subnet"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["ansible-host"]
}