terraform {
  required_version = ">= 1.5.0"

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "google" {
  project = "project-aeeb97f2-604e-4484-aa7"
  region  = "us-central1"
}


# VPC Network
resource "google_compute_network" "main" {
  name                    = "main-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "public" {
  count = length(var.subnet_name)

  name          = "main-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.main.id
}

/* VM Instance
resource "google_compute_instance" "example" {
  name         = "todo"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts"
    }
  }

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.main.id
    access_config {}  # Gives public IP
  }
}
*/