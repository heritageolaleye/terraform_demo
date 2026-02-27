# Automating AWS Infrastructure Using Terraform

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

