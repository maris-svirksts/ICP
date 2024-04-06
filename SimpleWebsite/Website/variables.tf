# Define a variable for user data to configure EC2 instances with unique content
variable "user_data" {
  default = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    # PHP installation
    sudo apt-get install -y libapache2-mod-php php-mysql
    # MySQL installation (non-interactive)
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password random_root_password'
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password random_root_password'
    sudo apt-get install -y mysql-server
    # Securing MySQL installation (example commands, adjust as necessary)
    sudo mysql -u root -prandom_root_password -e "DELETE FROM mysql.user WHERE User='';"
    sudo mysql -u root -prandom_root_password -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    sudo mysql -u root -prandom_root_password -e "DROP DATABASE IF EXISTS test;"
    sudo mysql -u root -prandom_root_password -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    sudo mysql -u root -prandom_root_password -e "FLUSH PRIVILEGES;"
    # MySQL database setup
    sudo mysql -u root -prandom_root_password -e "CREATE DATABASE youtube;"
    sudo mysql -u root -prandom_root_password -e "USE youtube; CREATE TABLE register (UserName varchar(255), Password varchar(255));"
    sudo mysql -u root -prandom_root_password -e "CREATE USER 'DBname'@'localhost' IDENTIFIED BY 'random_root_password';"
    sudo mysql -u root -prandom_root_password -e "GRANT ALL PRIVILEGES ON youtube.* TO 'DBname'@'localhost';"
    sudo mysql -u root -prandom_root_password -e "FLUSH PRIVILEGES;"
    # Apache restart
    sudo systemctl restart apache2
    echo "<!DOCTYPE html><html><head><title>Save to Random Database Game</title><style>form{padding-top:120px;text-align:center;font-size:30px;}input{width:250px;height:40px;font-size:30px;}</style></head><body><form method='post' action='index.php'>Username : <input type='text' name='username'><br><br>Password : <input type='password' name='password'><br><br><input type='submit' value='Submit'></form></body></html>" | sudo tee /var/www/html/index.html
    echo "<?php \$username = filter_input(INPUT_POST, 'username', FILTER_SANITIZE_STRING); \$password = filter_input(INPUT_POST, 'password', FILTER_SANITIZE_STRING);  if (empty(\$username)) { die('Username should not be empty'); }  if (empty(\$password)) { die('Password should not be empty'); }  \$host = 'localhost'; \$dbusername = 'DBname'; \$dbpassword = 'random_root_password'; \$dbname = 'youtube';  \$conn = new mysqli(\$host, \$dbusername, \$dbpassword, \$dbname); if (\$conn->connect_error) { die('Connect Error (' . \$conn->connect_errno . ') ' . \$conn->connect_error); } \$sql = \$conn->prepare('INSERT INTO register (username, password) VALUES (?, ?)'); \$sql->bind_param('ss', \$username, \$password);  if (\$sql->execute()) { echo 'New record is inserted successfully'; } else { echo 'Error: ' . \$sql->error; }  \$sql->close(); \$conn->close(); ?>" | sudo tee /var/www/html/index.php
    # Instance Identification
    INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
    echo "This page was created by Terraform on instance: $INSTANCE_ID" | sudo tee /var/www/html/test.html
    echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
 EOF
  # Bash script for initial setup of the EC2 instance. It updates packages, installs Apache, PHP, MySQL and displays a unique page. Uses https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html to identify instance.
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  type        = string
}

variable "public_subnet_3_id" {
  description = "Public Subnet 3 ID"
  type        = string
}
