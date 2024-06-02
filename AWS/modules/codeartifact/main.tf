resource "aws_codeartifact_domain" "domain" {
  domain = var.domain_name
}

resource "aws_codeartifact_repository" "repository" {
  repository = var.repository_name
  domain     = aws_codeartifact_domain.domain.domain
}

resource "aws_codeartifact_domain_permissions_policy" "policy" {
  domain      = aws_codeartifact_domain.domain.domain
  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "codeartifact:*",
        Resource = "*"
      },
    ],
  })
}
