# AWS Simple Website Terraform Configuration

This Terraform configuration sets up a simple web application infrastructure on AWS. It provisions an Auto Scaling Group of EC2 instances running Apache and PHP, backed by a MySQL database for storage. The infrastructure includes an Application Load Balancer (ALB) to distribute incoming traffic across the instances.

## Prerequisites

- AWS Account
- Terraform installed on your local machine
- AWS CLI installed and configured on your local machine
- Basic knowledge of Terraform and AWS

## Setup Instructions

1. **Clone the Repository**: Begin by cloning this repository to your local machine, or download the Terraform configuration files to a local directory.

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Configure AWS Credentials**: Ensure your AWS credentials are configured properly by setting up the AWS CLI or by configuring Terraform's AWS provider with the necessary access keys and secrets.

3. **Initialize Terraform**: Run the following command to initialize Terraform, allowing it to download necessary providers and modules.

    ```bash
    terraform init
    ```

4. **Review the Plan**: Before applying the configuration, it's good practice to review the plan and ensure everything is set up as expected.

    ```bash
    terraform plan
    ```

5. **Apply the Configuration**: Apply the Terraform configuration to provision the resources on AWS.

    ```bash
    terraform apply
    ```

    Confirm the action by typing `yes` when prompted.

6. **Access the Web Application**: After the infrastructure is provisioned, you can access the web application through the DNS name of the Application Load Balancer (ALB). You can find the ALB's DNS name as an output of the Terraform apply command.

## Configuration Details

- **AWS Provider**: Configures the AWS provider to use the `eu-north-1` region.
- **EC2 Instances**: Provisions EC2 instances with Apache and PHP installed. Each instance also has MySQL installed for database storage. The instances are configured using user data scripts for initial setup.
- **Application Load Balancer (ALB)**: Distributes incoming traffic across the EC2 instances to ensure high availability and load balancing.
- **Security Groups**: Sets up security groups to allow inbound traffic on ports 22 (SSH) and 80 (HTTP) to the ALB, and configures egress to allow all outbound traffic.
- **Auto Scaling Group**: Manages the EC2 instances, ensuring that a specified number of instances are always running and distributing them across multiple availability zones for high availability.

## Important Notes

- **Security**: This configuration opens port 22 (SSH) to the internet. For production environments, it's recommended to restrict SSH access to known IP addresses.
- **Database Password**: The MySQL root password is set in the user data script. It's recommended to handle sensitive information such as passwords more securely, especially in production environments.
- **Customization**: You can customize the configuration by editing the Terraform files. For example, you might want to change the instance type, the number of instances, or the AWS region.
- **End Result**: The final end results will be very different and can be explained easier through the following, rough diagram:

![Diagram](Website-V1.jpg)