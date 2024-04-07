# Define launch configuration for EC2 instances using the AMI and user data
resource "aws_launch_configuration" "micro" {
  name_prefix          = "terraform-lc-example-"
  image_id             = data.aws_ami.amazon_linux.id
  instance_type        = "t3.micro" # Specifies the size of the instance
  user_data            = local.user_data
  security_groups      = [aws_security_group.ec2.id] # Associates instances with the defined security group
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "Maris_Svirksts"

  lifecycle {
    create_before_destroy = true # Minimizes downtime during update or replacement
  }
}
