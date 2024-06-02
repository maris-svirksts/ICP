output "codebuild_service_role_arn" {
  value = aws_iam_role.codebuild_service_role.arn
}

output "project_name" {
  value = aws_codebuild_project.project.name
}
