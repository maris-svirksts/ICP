variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "instance_tag" {
  description = "Tag for the EC2 instance"
  type        = string
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for the EC2 instance"
  type        = list(string)
}
