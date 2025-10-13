module "moreno_stack" {
  source = "../../"

  # Required variables
  aws_region         = var.aws_region
  project_name       = var.project_name
  environment        = var.environment
    
  # Network configuration
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  
  # Instance configuration
  instance_type      = var.instance_type
  
  # Security
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  ssh_public_key     = var.ssh_public_key
  
  # AMI
  ami_id             = var.ami_id
  
  # Spot instance
  use_spot_instance  = var.use_spot_instance
  
  # Tags
  default_tags           = var.default_tags
  
  # Lambda schedule
  ec2_monitor_schedule   = var.ec2_monitor_schedule
}
