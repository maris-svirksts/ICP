locals {
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y php8.2 httpd amazon-efs-utils unzip
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    # Mount and connect to EFS
    sudo rm -fr /var/www/html/*
    mount -t efs -o tls ${aws_efs_file_system.webserver_files.id}:/ /var/www/html
    # Download AWS SDK for PHP and Website Files
    curl "https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip" -o "/tmp/aws.zip"
    curl -JL "https://github.com/maris-svirksts/ICP/raw/main/SimpleWebsite/SupportFunctions/Files.zip" -o "/tmp/website_files.zip"
    # Extract the files
    sudo unzip /tmp/aws.zip -d /var/www/html/vendor
    sudo unzip /tmp/website_files.zip -d /var/www/html
    # Clean up the downloaded zip files
    sudo rm /tmp/aws.zip
    sudo rm /tmp/website_files.zip
    # Set Permissions
    sudo usermod -a -G apache ec2-user
    sudo chown -R ec2-user:apache /var/www
    sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
    >> /var/log/website_creation.log 2>&1
EOF
}
