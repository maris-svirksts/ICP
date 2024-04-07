# Fetch the latest Amazon Linux AMI information for instance creation
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  owners = ["amazon"] # The AWS account name of the AMI owner
}
