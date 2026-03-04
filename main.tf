terraform {
  required_version = ">= 1.5.0"

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}


# VPC Network
resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "public" {
  count = var.preferred_number_of_public_subnets

  name          = "main-subnet-${count.index}"
  ip_cidr_range = "10.${count.index}.0.0/16"
  region        = var.region
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