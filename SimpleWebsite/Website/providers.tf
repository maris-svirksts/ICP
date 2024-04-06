# AWS / Simple Website: Homework.

# Define required Terraform version and required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify AWS provider source
      version = "5.43.0"        # Specify AWS provider version
    }
  }
  backend "s3" {
    bucket         = "terraform-state"
    region         = "eu-north-1"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# Configure the AWS provider with the desired region
provider "aws" {
  region = "eu-north-1" # AWS region where resources will be created
}
