variable "elb_name" {
  description = "Name of the Elastic Load Balancer"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for the ELB"
  type        = list(string)
}

variable "instances" {
  description = "List of EC2 instance IDs"
  type        = list(string)
}
