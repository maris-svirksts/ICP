# Define launch configuration for EC2 instances using the AMI and user data
resource "aws_launch_configuration" "micro" {
  name_prefix     = "terraform-lc-example-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro" # Specifies the size of the instance
  user_data       = var.user_data
  security_groups = [aws_security_group.alb_sg.id] # Associates instances with the defined security group

  lifecycle {
    create_before_destroy = true # Minimizes downtime during update or replacement
  }
}
