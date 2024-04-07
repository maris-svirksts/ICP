variable "tfstate_bucket_name" {
  description = "The name of the tfstate S3 bucket to be created."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.tfstate_bucket_name))
    error_message = "The bucket name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "state_lock_table" {
  description = "The name of the state lock DynamoDB table to be created."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.state_lock_table))
    error_message = "The table name must contain only alphanumeric characters, underscores, and dashes."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones in the region"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    "Project"     = "Setup"
    "Environment" = "Development"
  }
}
