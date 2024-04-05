# Define an Auto Scaling Group to manage EC2 instances
resource "aws_autoscaling_group" "bar" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.micro.name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
  # Configures scaling parameters and distributes instances across 3 zones for high availability

  target_group_arns = [aws_lb_target_group.asg.arn]

  lifecycle {
    create_before_destroy = true
  }
}

# CloudWatch Alarm to trigger the scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This alarm triggers when CPU utilization exceeds 70% for 10 minutes."
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bar.name
  }
}

# Attach the scaling policy to the Auto Scaling Group
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "terraform-asg-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.bar.name

  policy_type = "SimpleScaling"
}
