variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}

variable "service_role_arn" {
  description = "ARN of the service role for CodePipeline"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for pipeline artifacts"
  type        = string
}

variable "repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "branch_name" {
  description = "Branch name for CodeCommit repository"
  type        = string
}

variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "application_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  type        = string
}
