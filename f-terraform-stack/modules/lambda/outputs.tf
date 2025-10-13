output "function_arn" {
  description = "ARN of the EC2 Monitor Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "Name of the EC2 Monitor Lambda function"
  value       = aws_lambda_function.this.function_name
}
