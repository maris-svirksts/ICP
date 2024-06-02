output "application_name" {
  value = aws_codedeploy_app.app.name
}

output "deployment_group_name" {
  value = aws_codedeploy_deployment_group.group.deployment_group_name
}

output "codedeploy_service_role_arn" {
  value = aws_iam_role.codedeploy_service_role.arn
}