# AWS Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = local.tags
  }
}

# Networking Module - VPC, Subnets, Internet Gateway
module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

# Bastion Module - Jump Host for SSH Access
module "bastion" {
  source = "./modules/bastion"

  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  subnet_id          = module.networking.public_subnet_id
  instance_type      = var.instance_type
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  ssh_public_key     = var.ssh_public_key
  ami_id             = var.ami_id
  use_spot_instance  = var.use_spot_instance
}

# EC2 Monitor Lambda - Stops EC2 instances on schedule
module "ec2_monitor_lambda" {
  source = "./modules/lambda"

  project_name        = var.project_name
  environment         = var.environment
  monitored_regions   = "us-east-1,us-east-2,us-west-2"
  schedule_expression = var.ec2_monitor_schedule
}
