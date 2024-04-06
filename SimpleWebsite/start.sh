#!/bin/bash

# Check if a bucket name and state lock DynamoDB table arguments are provided.
if [ -z "$1" ]  || [ -z "$2" ]; then
  echo "Usage: $0 <bucket-name> <dynamodb-table-name> # For <bucket-name> only lowercase alphanumeric characters, dots and hyphens allowed, for <dynamodb-table-name> only alphanumeric characters, underscores, dashes and dots allowed."
  exit 1
fi

# Prepare environment.
python supportFunctions/preparations.py

# Check if Python script executed successfully
if [ $? -eq 0 ]; then
    echo "Python script executed successfully. Proceeding with Terraform..."

    # Setup tfstate S3 bucket and state lock DynamoDB table.
    cd Setup || exit

    terraform init
    terraform plan -var="tfstate_bucket_name=$1" -var="state_lock_table=$2"
    terraform apply -var="tfstate_bucket_name=$1" -var="state_lock_table=$2" # -auto-approve # Warning: make sure that no one can change your infrastructure outside of your Terraform workflow.

    # Run the main script.
    cd ../Website || exit

    terraform init \
        -reconfigure \
        -backend-config="bucket=$1" \
        -backend-config="dynamodb_table=$2"
    terraform plan
    terraform apply # -auto-approve

else
    echo "Python script failed. Halting execution."
    exit 1
fi
