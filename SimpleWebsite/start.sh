#!/bin/bash

# This script initializes the infrastructure required for the project using Terraform and then deploys the website.
# It requires the following named arguments:
# --bucket-name for S3 bucket used for Terraform state files.
# --dynamodb-table-name for DynamoDB table used for Terraform state locking.
# --ssh-key for the SSH key file used for secure connections.

# Initialize variables to empty strings
TFSTATE_BUCKET_NAME=""
STATE_LOCK_TABLE=""
SSH_KEY=""

# Function to process each command-line option
process_argument() {
    case "$1" in
        --bucket-name)
            TFSTATE_BUCKET_NAME="$2"
            return 2
            ;;
        --dynamodb-table-name)
            STATE_LOCK_TABLE="$2"
            return 2
            ;;
        --ssh-key)
            SSH_KEY="$2"
            return 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 --bucket-name <bucket-name> --dynamodb-table-name <dynamodb-table-name> --ssh-key <ssh-key-path>"
            exit 1
            ;;
    esac
}

# Process the command-line arguments
while [ "$#" -gt 0 ]; do
    process_argument "$@"
    shift $?
done

# Check if the required variables are set
if [ -z "$TFSTATE_BUCKET_NAME" ] || [ -z "$STATE_LOCK_TABLE" ] || [ -z "$SSH_KEY" ]; then
    echo "Usage: $0 --bucket-name <bucket-name> --dynamodb-table-name <dynamodb-table-name> --ssh-key <ssh-key-path>"
    exit 1
fi

# Run Python script to prepare the environment.
python SupportFunctions/preparations.py

# Check if the Python script executed successfully.
if [ $? -eq 0 ]; then
    echo "Python script executed successfully. Proceeding with Terraform setup..."

    # Initialize and apply Terraform configuration in the Setup directory.
    cd Setup || exit
    terraform init
    terraform plan -var="tfstate_bucket_name=$TFSTATE_BUCKET_NAME" -var="state_lock_table=$STATE_LOCK_TABLE"
    terraform apply -var="tfstate_bucket_name=$TFSTATE_BUCKET_NAME" -var="state_lock_table=$STATE_LOCK_TABLE"

    # Extract output variables from the Terraform setup.
    VPC_ID=$(terraform output -raw vpc_id)
    PUBLIC_SUBNETS=$(terraform output -json public_subnets)

    # Navigate to the Website directory to configure and deploy the website.
    cd ../Website || exit

    # Backup and update the terraform.tfvars file with the new configuration.
    cp terraform.tfvars terraform.tfvars.bak
    {
        echo ""
        echo "vpc_id=\"$VPC_ID\""
        echo "public_subnets=$PUBLIC_SUBNETS"
    } >>terraform.tfvars

    # Reinitialize Terraform with the updated configuration.
    terraform init -reconfigure -backend-config="bucket=$TFSTATE_BUCKET_NAME" -backend-config="dynamodb_table=$STATE_LOCK_TABLE"
    terraform plan
    terraform apply

    # Retrieve information for SSH connection and transfer website files to the server.
    ASG_NAME=$(terraform output -raw autoscaling_group)
    INSTANCE_ID=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$ASG_NAME" --query "AutoScalingGroups[].Instances[0].InstanceId" --output text)
    PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

    # Ensure the SSH host is known.
    ssh-keyscan $PUBLIC_IP >>~/.ssh/known_hosts
    # Transfer files using the specified SSH key.
    scp -i "$SSH_KEY" "../SupportFunctions/Files/"* ec2-user@$PUBLIC_IP:/var/www/html

else
    echo "Python script failed. Halting execution."
    exit 1
fi
