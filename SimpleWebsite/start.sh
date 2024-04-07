#!/bin/bash

# Check if a bucket name and state lock DynamoDB table arguments are provided.
if [ -z "$1" ] || [ -z "$2" ]; then
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

    # Capture vpc outputs
    vpc_id=$(terraform output -raw vpc_id)
    public_subnet_1_id=$(terraform output -raw public_subnet_1_id)
    public_subnet_2_id=$(terraform output -raw public_subnet_2_id)
    public_subnet_3_id=$(terraform output -raw public_subnet_3_id)

    # Run the main script.
    cd ../Website || exit

    # Backup and then update the terraform.tfvars file.
    cp -f terraform.tfvars terraform.tfvars.bak
    echo "" >> terraform.tfvars # Make sure we start at a new line
    echo "vpc_id=\"$vpc_id\"" >> terraform.tfvars
    echo "public_subnet_1_id=\"$public_subnet_1_id\"" >> terraform.tfvars
    echo "public_subnet_2_id=\"$public_subnet_2_id\"" >> terraform.tfvars
    echo "public_subnet_3_id=\"$public_subnet_3_id\"" >> terraform.tfvars

    terraform init \
        -reconfigure \
        -backend-config="bucket=$1" \
        -backend-config="dynamodb_table=$2"
    terraform plan
    terraform apply \
        -var="vpc_id=${vpc_id}" # -auto-approve

    # Copy files to the webserver EFS mount point.
    ASG_NAME=$(terraform output -raw autoscaling_group)
    INSTANCE_ID=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$ASG_NAME" --query "AutoScalingGroups[].Instances[0].InstanceId" --output text)
    PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

    ssh-keyscan $PUBLIC_IP >> ~/.ssh/known_hosts
    scp -i "../../../Maris_Svirksts.pem" "../SupportFunctions/Files/index.html" "../SupportFunctions/Files/index.php" "../SupportFunctions/Files/info.php" ec2-user@$PUBLIC_IP:/var/www/html

else
    echo "Python script failed. Halting execution."
    exit 1
fi
