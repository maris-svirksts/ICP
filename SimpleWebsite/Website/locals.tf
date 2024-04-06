# Define a variable for user data to configure EC2 instances with unique content
locals {
  user_data = <<-EOF
    #!/bin/bash
    {
      sudo yum update y
      sudo yum install -y httpd
      sudo systemctl start httpd.service
      sudo systemctl enable httpd.service
      # Install and connect to EFS
      sudo yum install -y amazon-efs-utils
      sudo rm -fr /var/www/html/*
      mount -t efs -o tls ${aws_efs_file_system.webserver_files.id}:/ /var/www/html
    } >> /var/log/user_data.log 2>&1
    # Add Files
    echo "<!DOCTYPE html><html><head><title>Save to Random Database Game</title><style>form{padding-top:120px;text-align:center;font-size:30px;}input{width:250px;height:40px;font-size:30px;}</style></head><body><form method='post' action='index.php'>Username : <input type='text' name='username'><br><br>Password : <input type='password' name='password'><br><br><input type='submit' value='Submit'></form></body></html>" | sudo tee /var/www/html/index.html
    echo "" | sudo tee /var/www/html/index.php
    # Instance Identification
    INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
    echo "This page was created by Terraform on instance: $INSTANCE_ID" | sudo tee /var/www/html/test.html
    echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
 EOF
  # Bash script for initial setup of the EC2 instance. It updates packages, installs Apache, PHP, MySQL and displays a unique page. Uses https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html to identify instance.
}