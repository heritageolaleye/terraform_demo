terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  profile = "Adelafight"
}