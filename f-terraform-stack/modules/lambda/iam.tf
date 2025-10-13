# IAM Role for EC2 Monitor Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-ec2-monitor-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Basic Lambda execution policy (CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# EC2 permissions (Stop/Start instances)
resource "aws_iam_role_policy" "ec2_permissions" {
  name = "${var.project_name}-ec2-monitor-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Start*",
          "ec2:Stop*",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}
