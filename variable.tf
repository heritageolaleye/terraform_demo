variable "region" {
    default = "us-east-1"
  
}

variable "vpc_cidr" {
    default = "167.16.0.0/16"
  
}

variable "enable_dns_support" {
    default = true
  
}

variable "enable_dns_hostnames" {
    default = true
  
}

variable "preferred_number_of_public_subnets" {
    default = null
  
}

variable "vpc_tags"{
 description = "Tags to be applied to the VPC"
 type        = map(string)
 default = {
     Environment = "production"
     Terraform   = "true"
     Project     = "PBL"
 }
}