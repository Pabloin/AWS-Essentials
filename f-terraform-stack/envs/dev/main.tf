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
  
  # Tags
  default_tags       = var.default_tags
  
  # AMI
  ami_id             = var.ami_id
}
