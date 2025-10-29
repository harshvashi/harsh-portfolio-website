# Backend configuration for storing Terraform state
# This keeps your state file in S3 with locking via DynamoDB

terraform {
  backend "s3" {
    bucket         = "harsh-portfolio-terraform-state" # Change this to your unique bucket name
    key            = "portfolio/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true

    # Uncomment after creating the S3 bucket and DynamoDB table manually
    # See setup instructions below
  }
}