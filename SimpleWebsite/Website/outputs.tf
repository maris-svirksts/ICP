# Output the DNS name of the ALB for accessing the application
output "alb_dns_name" {
  value       = aws_lb.my_alb.dns_name
  description = "The DNS name of the ALB"
  # Provides a URL for accessing the load-balanced application
}

output "autoscaling_group" {
  value = aws_autoscaling_group.ec2_scaler.name
  description = "Auto Scaling Group Name"
}
