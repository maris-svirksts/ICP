# Define an Auto Scaling Group to manage EC2 instances
resource "aws_autoscaling_group" "ec2_scaler" {
  name                 = var.ec2_scaler_name
  launch_configuration = aws_launch_configuration.micro.name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_size
  vpc_zone_identifier  = var.public_subnets
  # Configures scaling parameters and distributes instances across 3 zones for high availability

  target_group_arns = [aws_lb_target_group.asg.arn]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_efs_mount_target.mount_target] # EFS mounting to the EC2 instance fails otherwise.
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
  alarm_description   = "This alarm triggers when CPU utilization exceeds 70% for 5 minutes."
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_scaler.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "This alarm triggers when CPU utilization falls at or below 50% for 5 minutes."
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_scaler.name
  }
}


# Attach the scaling policy to the Auto Scaling Group
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "terraform-asg-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_scaler.name

  policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "terraform-asg-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_scaler.name

  policy_type = "SimpleScaling"
}
