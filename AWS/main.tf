provider "aws" {
  region = "us-west-2"
}

module "codecommit" {
  source          = "./modules/codecommit"
  repository_name = "example-repo"
  description     = "Example HTML site repository"
}

module "codeartifact" {
  source          = "./modules/codeartifact"
  domain_name     = "example-domain"
  repository_name = "example-repo"
}

module "ec2" {
  source              = "./modules/ec2"
  ami                 = data.aws_ami.amazon_linux.id
  instance_type       = "t2.micro"
  instance_tag        = "example-ec2-instance"
  user_data           = <<-EOF
                        #!/bin/bash
                        sudo yum install -y httpd
                        sudo systemctl start httpd
                        sudo systemctl enable httpd
                        EOF
  availability_zones  = ["us-west-2a"]
}

/*module "alb" {
  source           = "./modules/alb"
  alb_name         = "example-alb"
  security_groups  = ["sg-0123456789abcdef0"]  # Replace with security group IDs
  subnets          = ["subnet-0123456789abcdef0"]  # Replace with subnet IDs
  vpc_id           = "vpc-0123456789abcdef0"  # Replace with VPC ID
  instance_id      = module.ec2.instance_id
}*/

module "codebuild" {
  source           = "./modules/codebuild"
  project_name     = "example-codebuild"
  description      = "Build project for HTML site"
  service_role_arn = module.codebuild.codebuild_service_role_arn
  s3_bucket        = aws_s3_bucket.example_bucket.bucket
  repository_url   = module.codecommit.repository_clone_url_http
  buildspec        = file("buildspec.yml")
}

module "codedeploy" {
  source               = "./modules/codedeploy"
  application_name     = "example-app"
  deployment_group_name= "example-deployment-group"
  service_role_arn     = module.codedeploy.codedeploy_service_role_arn
  ec2_instance_tag     = "example-ec2-instance"
  # elb_name             = module.elb.elb_name
}

module "codepipeline" {
  source               = "./modules/codepipeline"
  pipeline_name        = "example-pipeline"
  service_role_arn     = module.codepipeline.codepipeline_service_role_arn
  s3_bucket            = aws_s3_bucket.example_bucket.bucket
  repository_name      = "example-repo"
  branch_name          = "main"
  project_name         = module.codebuild.project_name
  application_name     = module.codedeploy.application_name
  deployment_group_name= module.codedeploy.deployment_group_name
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-pipeline-bucket"
}

# Fetch the latest Amazon Linux AMI information for instance creation
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  owners = ["amazon"] # The AWS account name of the AMI owner
}
