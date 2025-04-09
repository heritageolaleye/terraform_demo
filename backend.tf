# Example S3 backend configuration
terraform {
  backend "s3" {
    bucket         = "heritage-terraform-s3-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}