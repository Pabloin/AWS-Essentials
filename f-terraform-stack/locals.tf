locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_name
  }
  
  tags = merge(local.common_tags, var.default_tags)
}
