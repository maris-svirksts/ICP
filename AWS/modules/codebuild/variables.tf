variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "description" {
  description = "Description of the CodeBuild project"
  type        = string
  default     = ""
}

variable "service_role_arn" {
  description = "ARN of the service role for CodeBuild"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for build artifacts"
  type        = string
}

variable "repository_url" {
  description = "URL of the CodeCommit repository"
  type        = string
}

variable "buildspec" {
  description = "Buildspec file for CodeBuild"
  type        = string
}
