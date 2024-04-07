output "vpc_id" {
  description = "The ID of the VPC created"
  value       = aws_vpc.terraform_vpc.id
}

output "public_subnets" {
  description = "The IDs of the public subnets created"
  value       = aws_subnet.public_subnet.*.id
}
