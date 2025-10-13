variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "moreno-stack"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into bastion"
  type        = list(string)
}

variable "ssh_public_key" {
  description = "SSH public key for bastion host access"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use for bastion (optional - will auto-detect Ubuntu 24.04 if not specified)"
  type        = string
  default     = ""
}

variable "use_spot_instance" {
  description = "Whether to use Spot instance for bastion (up to 90% cost savings, persistent with stop behavior)"
  type        = bool
  default     = true
}

variable "run_custom_setup" {
  description = "Whether to run custom-bastion-setup.sh after deployment"
  type        = bool
  default     = false
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "ec2_monitor_schedule" {
  description = "EventBridge schedule expression for EC2 monitor"
  type        = string
  default     = "cron(0 22 * * ? *)"
}
