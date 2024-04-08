variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "desired_size" {
  description = "Desired size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "ec2_scaler_name" {
  description = ""
  type        = string
  default     = "terraform-ec2-scaler"
}

variable "vpc_id" {
  description = "The VPC ID where resources will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnet IDs for deploying resources"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    "Project"     = "Website"
    "Environment" = "Development"
  }
}
