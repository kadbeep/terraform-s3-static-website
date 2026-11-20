![Terraform CI](https://github.com/kadbeep/terraform-s3-static-website/actions/workflows/terraform-ci.yml/badge.svg?branch=main)

# Host a Static Website on Amazon S3 using Terraform

Terraform code that creates an S3 bucket with static website hosting,
a public-read bucket policy, and uploads index.html and error.html.

## Usage
    terraform init
    terraform plan
    terraform apply
    curl -i $(terraform output -raw website_url)
    terraform destroy

Region: us-west-2 (configurable in variables.tf)
