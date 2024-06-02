variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "security_groups" {
  description = "List of security groups to assign to the ALB"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnets to associate with the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the ALB and target group are deployed"
  type        = string
}

variable "instance_id" {
  description = "ID of the instance to attach to the target group"
  type        = string
}
