# Define a variable for user data to configure EC2 instances with unique content
locals {
  user_data = <<-EOF
    #!/bin/bash
    {
      sudo yum update -y
      sudo yum install -y php8.2
      sudo yum install -y httpd
      sudo systemctl start httpd.service
      sudo systemctl enable httpd.service
      # Install and connect to EFS
      sudo yum install -y amazon-efs-utils
      sudo rm -fr /var/www/html/*
      mount -t efs -o tls ${aws_efs_file_system.webserver_files.id}:/ /var/www/html
      # Set Permissions
      sudo usermod -a -G apache ec2-user
      sudo chown -R ec2-user:apache /var/www
      sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
      # Install unzip utility
      sudo yum install -y unzip
      # Download AWS SDK for PHP
      curl "https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip" -o "/tmp/aws.zip"
      # Extract the SDK to /var/www/html
      sudo unzip /tmp/aws.zip -d /var/www/html/vendor
      # Clean up the downloaded zip file
      sudo rm /tmp/aws.zip
   } >> /var/log/user_data.log 2>&1
 EOF
  # Bash script for initial setup of the EC2 instance. It updates packages, installs Apache, PHP, MySQL and displays a unique page. Uses https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html to identify instance.
}