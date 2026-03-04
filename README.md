# Automating AWS Infrastructure Using Terraform

# Table of Content

1. [Prerequisites](#prerequisites)
2. [Required Tools](#required-tools)
3. [GCP CLI Setup](#gcp-cli-setup)
4. [Buckets Backend Configuration](#buckets-backend-configuration)
5. [Understanding Terraform Concepts](#understanding-terraform-concepts)
6. [Infrastructure Code Structure](#infrastructure-code-structure)
7. [VPC and Networking Configuration (HARDCODED VERSION)](#vpc-and-networking-configuration-hardcoded-version)
8. [VPC and Networking Configuration (SoftCoded - Introducing Variable - VERSION)](#vpc-and-networking-configuration-softcoded---introducing-variable---version)
9. [Conclusion](#conclusion)

After successfully building AWS infrastructure manually for 2 websites, we will now automate the entire process using Terraform. This automation will ensure consistency, repeatability, and easier maintenance of our infrastructure.

# Prerequisites

Before diving into Terraform configuration, ensure you have the following prerequisites in place

# Required Tools

- Google Account with administrative access
- Terraform CLI (latest version)
- Google CLI (version 2.x or later)
- Python 3.6 or higher (for boto3)
- A code editor (VS Code recommended)

# Knowledge Requirements

- Basic understanding of GCP services
- Familiarity with command line operations
- Basic understanding of JSON/YAML formats

# GCP Service Account
-  Log into GCP console
- Search for "service account" 

![terraform](/images/gcp9.png)

# GCP CLI Setup

1. Configure AWS CLI 

```bash
sudo snap install google-cloud-cli --classic
gcloud auth login
```
![terraform](/images/gcp5.png)

![terraform](/images/gcp4.png)

# Buckets Backend Configuration

1. Creating Buckets for Terraform State.

1. Create a bucket: Navigate to buckets in GCP
    - Name format:  heritage-terraform-bucket
![terraform](/images/gcp10.png)

2. Verify Bucket Creation:

```bash
gcloud config get-value project
```
![terraform](/images/gcp11.png)

# Understanding Terraform Concepts

# Key Terraform Terminology

1. Attribute:
  - These are properties of resources that are either set by the provider or computed during execution

```bash
resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false
}
```

2. Resource:
   - Are infrastructure objects managed by Terraform

```bash
resource "google_compute_instance" "example" {
  name         = "todo"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts"
    }
  }
```

3. Interpolation:
   - These are references to other resource attributes or variables

```bahresource "google_compute_subnetwork" "public" {
  count = var.preferred_number_of_public_subnets

  name          = "main-subnet-${count.index}"
  ip_cidr_range = "10.${count.index}.0.0/16"
  region        = var.region  # This is an interpolation
  network       = google_compute_network.main.id
}
```

4. Provider:
   - This is a plugin for managing resources in a specific cloud platform

```bash
provider "google" {
  project = var.project_id
  region  = var.region
}
``` 
5. Variables:
   - These are like containers/boxes to help you store reusable values through out your configuration file.

```bash
variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "project-aeeb97f2-604e-4484-aa7"
}
```

# Infrastructure Code Structure

# Project Directory Setup

1. Create Project Directory:

```bash
mkdir PBL
cd PBL
```

2. Create Basic File Structure:

```bash
touch main.tf
```

# VPC and Networking Configuration (HARDCODED VERSION)

# Provider Configuration

1. Set up AWS Provider and Create VPC:

```bash
provider "google" {
  project = var.project_id
  region  = var.region
}


# VPC Network
resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false
}
```

Now for us to create this VPC network in our google cloud, terraform would need to download some plugins to enable it communicate properly with aws in the creation of our specs above. To download this plugins, we run terraform init

2. Initialize and Plan:

```bash
terraform init
terraform plan
```
![gcp](/images/gcp2.png)

![gcp](/images/gcp.png)

# Subnet Configuration

According to our architectural design, we require 6 subnets:

- 2 public
- 2 private for webservers
- 2 private for data layer

Let us create the first 2 public subnets.

Add below configuration to the main.tf file:

```bash
resource "google_compute_subnetwork" "public1" {
  name          = "main-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.main.id
}

resource "google_compute_subnetwork" "public2" {
  name          = "main-subnet"
  ip_cidr_range = "10.0.1.0/16"
  region        = "us-central1"
  network       = google_compute_network.main.id
}
```
- We are creating 2 subnets and that is why we are declaring 2 resource blocks - one for each of the subnets.
- We are using the vpc_id argument to interpolate the value of the VPC id by setting it to google_compute_network.main.id. This way, Terraform knows what VPC to create the subnet within.

Run terraform plan and terraform apply

![gcp](/images/gcp14.png)

![gcp](/images/gcp12.png)

![gcp](/images/gcp13.png)

# [VPC and Networking Configuration (SoftCoded - Introducing Variable - VERSION)]

Now, we will run terraform destroy to remove all the resources we have created in our aws account through terraform so that we can redo it, this time around, in a more flexible, dynamic way.

![gcp](/images/gcp15.png)

Create a file called variables.tf, in this file is where we will declare our variables to use in the main.tf file. We could declare these variables in the main.tf file, but for the sake of making our work orderly and easy to read, we are separating the files for their respective purpose.

# Why is this segmentation important?

1. Separation of Concerns

   - Configuration logic (main.tf)
   - Variable declarations (variables.tf)
   - Variable values (terraform.tfvars)

2. Reusability
   - Same configuration can be used with different variables
   - Easy to replicate infrastructure across environments

3. Maintainability
   - Easier to read and understand
   - Simpler to update specific components
   - Better version control management

4. Security
   - Sensitive values can be kept separate
   - Different access controls for different files
   - Easier to implement GitOps practices  

```bash
sudo touch variables.tf
```
1. Variable Definition:

```bash
variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "project-aeeb97f2-604e-4484-aa7"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "main-network"
}

variable "preferred_number_of_public_subnets" {
  description = "Subnet name"
  type        = number
  default     = 2

}

variable "vm_name" {
  description = "Virtual machine name"
  type        = string
  default     = "todo"
}

variable "machine_type" {
  description = "VM machine type"
  type        = string
  default     = "e2-micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR ranges"
  type        = list(string)
}
```
2. Explicit variable Definitions

Create another file called terraform.tfvars

```bash
touch terraform.tfvars
```
This file sets actual values for the variables declared in variables.tf. It's used to:

- Override specific default values
- Set environment-specific configurations
- Keep sensitive values separate from main code

Find below and replicate the content of the terraform.tfvars file:

```bash
project_id   = "project-aeeb97f2-604e-4484-aa7"
region       = "us-central1"
network_name = "main-network"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
```
3. **Main Configuration Updates**: Once you have applied the values in the terraform.tfvars file, we will now proceed to the main.tf file. This file contains the primary infrastructure configuration. It:

- References variables using the var. prefix
- efines resources and their relationships
- Contains provider configurations

```bash
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
```
# Conclusion

Through this Infrastructure as Code (IaC) implementation with Terraform, we have successfully:

- Automated the creation of a production-grade VPC infrastructure
- Implemented dynamic subnet allocation across availability zones
- Established a maintainable and scalable code structure
- Applied AWS best practices for networking and security