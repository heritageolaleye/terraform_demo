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