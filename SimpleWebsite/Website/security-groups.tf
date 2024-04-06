# Create a security group for the ALB, allowing inbound HTTP traffic
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow port 80 to ALB"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Allows all inbound HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # Allows all outbound traffic
  }

  tags = {
    Name = "Amazon LB Security Group"
  }
}

# Create a security group for the EC2, allowing inbound HTTP and SSH traffic
resource "aws_security_group" "ec2" {
  name        = "example-security-group"
  description = "Security group for EC2 instance allowing HTTP and SSH"
  vpc_id      = aws_vpc.terraform_vpc.id

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}

