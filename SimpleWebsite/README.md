# Web Application Deployment Framework

## Overview

This framework is designed for deploying a scalable and secure web application on AWS with a focus on automation and infrastructure as code (IaC) through Terraform. It simplifies the setup of AWS resources, including networking, compute, storage, and more, with an emphasis on scalability.

![Diagram](Website-V1.jpg)

## Project Structure

- **Setup Directory (`Setup/`):** Terraform scripts for AWS foundational infrastructure like VPCs and networking.
- **Support Functions (`SupportFunctions/`):** Utilities and Python scripts for additional setup and deployment support.
- **Website Directory (`Website/`):** Terraform scripts for web-specific infrastructure, including EC2 instances, load balancers, and storage solutions.
- **Control Scripts:**
  - `start.sh`: Initiates the deployment, with parameters for specifying AWS Terraform state management resources.
  - `destroy.sh`: Removes all resources provisioned by the framework from AWS.

## Prerequisites

- An AWS account with adequate permissions.
- Terraform and Python installed on your local system.
- AWS CLI configured with your account credentials.

## Configuration and Deployment

### Initial Setup

1. **AWS CLI Configuration:** Ensure the AWS CLI is configured with credentials that have the necessary permissions.
2. **Variable Configuration:**
   - Copy `terraform.tfvars.example` in `Setup/` and `Website/` to `terraform.tfvars` and adjust them with your details.

### Deployment with `start.sh`

The `start.sh` script streamlines the deployment process, utilizing the following parameters for Terraform state management:

- **Terraform State S3 Bucket:** Specifies the S3 bucket to be used for storing Terraform state files.
- **Terraform State DynamoDB Table:** Designates the DynamoDB table for state locking and consistency checking.

#### Usage

```bash
./start.sh <S3BucketName> <DynamoDBTableName>
```

- `<S3BucketName>`: Replace with the name of a S3 bucket for Terraform state files.
- `<DynamoDBTableName>`: Replace with the name of a DynamoDB table for Terraform state locking.

**Example Command:**

```bash
./start.sh my-terraform-state-bucket my-terraform-state-lock
```

This command initializes the deployment, configuring Terraform to create the specified S3 bucket for state storage and the DynamoDB table for state locking.

### Teardown with `destroy.sh`

To dismantle all AWS resources created by this framework:

```bash
./destroy.sh
```

Ensure you've backed up any important data before executing this command, as it will irreversibly remove all deployed resources.
