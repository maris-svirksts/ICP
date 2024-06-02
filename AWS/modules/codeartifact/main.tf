resource "aws_codeartifact_domain" "domain" {
  domain = var.domain_name
}

resource "aws_codeartifact_repository" "repository" {
  repository = var.repository_name
  domain     = aws_codeartifact_domain.domain.domain
}

data "aws_iam_policy_document" "codeartifact_policy" {
  statement {
    actions   = ["codeartifact:*"]
    resources = ["*"]
  }
}

resource "aws_codeartifact_domain_permissions_policy" "policy" {
  domain          = aws_codeartifact_domain.domain.domain
  policy_document = data.aws_iam_policy_document.codeartifact_policy.json
}
