# EventBridge Schedule Rule
resource "aws_cloudwatch_event_rule" "ec2_monitor_schedule" {
  name                = "${var.project_name}-ec2-monitor-schedule"
  description         = "Triggers EC2 Monitor Lambda to stop instances"
  schedule_expression = var.schedule_expression

  tags = {
    Name = "${var.project_name}-ec2-monitor-schedule"
  }
}

# Archive Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda-function.py"
  output_path = "${path.module}/lambda-function.zip"
}

# EC2 Monitor Lambda Function
resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-ec2-monitor"
  role          = aws_iam_role.lambda_role.arn
  
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  handler     = "lambda-function.lambda_handler"
  runtime     = "python3.11"
  timeout     = 20
  memory_size = 128
  
  environment {
    variables = {
      ENVIRONMENT = var.environment
      REGIONS     = var.monitored_regions
    }
  }
  
  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.project_name}-ec2-monitor"
  retention_in_days = 7
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_monitor_schedule.arn
}

# EventBridge Target - connects schedule to Lambda
resource "aws_cloudwatch_event_target" "ec2_monitor_target" {
  rule      = aws_cloudwatch_event_rule.ec2_monitor_schedule.name
  target_id = "ec2-monitor-lambda"
  arn       = aws_lambda_function.this.arn
}
