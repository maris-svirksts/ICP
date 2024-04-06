output "vpc_id" {
  value       = aws_vpc.terraform_vpc.id
  description = "VPC ID"
}

output "public_subnet_1_id" {
  value       = aws_subnet.public_subnet_1.id
  description = "The ID of the public subnet 1"
}

output "public_subnet_2_id" {
  value       = aws_subnet.public_subnet_2.id
  description = "The ID of the public subnet 2"
}

output "public_subnet_3_id" {
  value       = aws_subnet.public_subnet_3.id
  description = "The ID of the public subnet 3"
}
