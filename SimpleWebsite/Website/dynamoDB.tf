resource "aws_dynamodb_table" "user_data" {
  name         = "UserData"
  billing_mode = "PAY_PER_REQUEST" # This mode automatically manages read and write capacity
  hash_key     = "UserId"

  attribute {
    name = "UserId"
    type = "S" # The 'S' type represents string data
  }

  tags = {
    Name        = "UserData"
    Environment = "Production"
  }
}

resource "aws_iam_role" "ec2_dynamodb_access_role" {
  name = "ec2_dynamodb_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "dynamodb_access_policy"
  description = "Policy to allow EC2 instance to access UserData DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "${aws_dynamodb_table.user_data.arn}"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_access_to_role" {
  role       = aws_iam_role.ec2_dynamodb_access_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_dynamodb_instance_profile"
  role = aws_iam_role.ec2_dynamodb_access_role.name
}
