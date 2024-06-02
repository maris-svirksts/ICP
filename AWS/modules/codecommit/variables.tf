variable "repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "description" {
  description = "Description of the CodeCommit repository"
  type        = string
  default     = ""
}
