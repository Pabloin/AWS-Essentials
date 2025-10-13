variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "monitored_regions" {
  description = "Comma-separated list of AWS regions to monitor"
  type        = string
  default     = "us-east-1,us-west-2,af-south-1"
}

variable "schedule_expression" {
  description = "EventBridge schedule expression (e.g., 'cron(0 22 * * ? *)' for 10 PM UTC daily)"
  type        = string
  default     = "cron(0 22 * * ? *)"
}
