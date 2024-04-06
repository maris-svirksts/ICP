# Fetch the latest Ubuntu AMI information for instance creation
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    # Filter to select the latest Ubuntu 22.04 LTS AMI
  }

  owners = ["amazon"] # The AWS account name of the AMI owner
}
