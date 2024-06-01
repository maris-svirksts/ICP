# main.tf

provider "aws" {
  region = "us-east-1"
}

# CodeCommit Repository
resource "aws_codecommit_repository" "app_repo" {
  repository_name = "app-repo"
  description     = "Repository for sample application code"
}

# CodeArtifact Domain and Repository
resource "aws_codeartifact_domain" "artifact_domain" {
  domain = "artifact-domain"
}

resource "aws_codeartifact_repository" "artifact_repo" {
  repository = "artifact-repo"
  domain     = aws_codeartifact_domain.artifact_domain.domain
}

data "aws_codeartifact_authorization_token" "auth_token" {
  domain  = aws_codeartifact_domain.artifact_domain.domain
  duration_seconds = 900
}

# S3 Bucket for Artifacts
resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "artifact-bucket"
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

# IAM Role for CodeDeploy
resource "aws_iam_role" "codedeploy_service_role" {
  name = "codedeploy_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attach" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_service_role" {
  name = "codepipeline_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attach" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

# CodeBuild Project
resource "aws_codebuild_project" "app_build" {
  name          = "app-build"
  service_role  = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true

    environment_variable {
      name  = "CODEARTIFACT_AUTH_TOKEN"
      value = data.aws_codeartifact_authorization_token.auth_token
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = file("buildspec.yml")
  }
}

# CodeDeploy Application and Deployment Group
resource "aws_codedeploy_app" "app" {
  name = "CodeDeployApp"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = "deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      value = "EC2Instance"
      type  = "KEY_AND_VALUE"
    }
  }
}

# CodePipeline Setup
resource "aws_codepipeline" "pipeline" {
  name     = "app-pipeline"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.app_repo.repository_name
        BranchName     = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.app_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      input_artifacts  = ["build_output"]
      version          = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
      }
    }
  }
}

# CloudWatch Monitoring
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/codebuild/${aws_codebuild_project.app_build.name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_metric_alarm" "build_fail_alarm" {
  alarm_name          = "BuildFailedAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FailedBuilds"
  namespace           = "AWS/CodeBuild"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"

  dimensions = {
    ProjectName = aws_codebuild_project.app_build.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

# SNS Topic for Alarms
resource "aws_sns_topic" "alerts" {
  name = "build-fail-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}
