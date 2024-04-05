# Create a security group for the ALB, allowing inbound HTTP traffic
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow ports 22, 80 to ALB"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Allows all inbound HTTP traffic
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Allows all inbound SSH traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # Allows all outbound traffic
  }
}
