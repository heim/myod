resource "google_compute_instance" "base-instance" {
  name         = "base-instance"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-d"

  tags = ["base-instance"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.base_instance_network.name
    access_config {
    }

  }

  metadata = {
    serial-port-logging-enable = true
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  metadata_startup_script = data.template_file.startup_script.rendered

}


data "template_file" "startup_script" {
  template = file("${path.module}/resources/startup_script.tpl.sh")
  vars = {
    app_properties = file("${path.module}/resources/properties/app.properties")
  }
}

resource "google_compute_network" "base_instance_network" {
  name                    = "base-instance-network"
  auto_create_subnetworks = true
}


resource "google_compute_firewall" "base_image_ssh" {
  name    = "base-image-ssh"
  network = google_compute_network.base_instance_network.name
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports = ["3389"]
  }
  target_tags = ["base-instance"]
}

output "server_ip" {
  value = google_compute_instance.base-instance.network_interface.0.access_config.0.nat_ip
}
