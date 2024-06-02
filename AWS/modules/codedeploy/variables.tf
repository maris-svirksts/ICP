variable "application_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  type        = string
}

variable "service_role_arn" {
  description = "ARN of the service role for CodeDeploy"
  type        = string
}

variable "ec2_instance_tag" {
  description = "Tag of the EC2 instance for deployment"
  type        = string
}

/*variable "elb_name" {
  description = "Name of the Elastic Load Balancer"
  type        = string
}*/
