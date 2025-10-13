variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where bastion will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet for bastion"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into bastion"
  type        = list(string)
}

variable "ssh_public_key" {
  description = "SSH public key for bastion host access"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "user_data_script" {
  description = "User data script for instance initialization"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "AMI ID to use for bastion (optional - will auto-detect Ubuntu 24.04 if not specified)"
  type        = string
  default     = ""
}

variable "use_spot_instance" {
  description = "Whether to use Spot instance instead of On-Demand (up to 90% cost savings, persistent with stop behavior)"
  type        = bool
  default     = false
}
