# Create an Application Load Balancer to distribute incoming traffic
resource "aws_lb" "my_alb" {
  name               = "my-alb-example"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id, var.public_subnet_3_id]

  enable_deletion_protection = false # Allows the ALB to be deleted without manual intervention
}

# Define a target group for routing requests to the appropriate instances
resource "aws_lb_target_group" "asg" {
  name     = "my-tg-example"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  # Configures health checks for ensuring instances are healthy before routing traffic
  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
  }
}

# Add a listener to the ALB for processing incoming HTTP traffic
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
    # Directs traffic to the target group
  }
}
