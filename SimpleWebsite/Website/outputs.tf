# Output the DNS name of the ALB for accessing the application
output "alb_dns_name" {
  value       = aws_lb.my_alb.dns_name
  description = "The DNS name of the ALB"
  # Provides a URL for accessing the load-balanced application
}

output "public_subnet_1" {
  value       = aws_subnet.public_subnet_1.id
  description = "The ID of the public subnet 1"
}

output "public_subnet_2" {
  value       = aws_subnet.public_subnet_2.id
  description = "The ID of the public subnet 2"
}

output "public_subnet_3" {
  value       = aws_subnet.public_subnet_3.id
  description = "The ID of the public subnet 3"
}
