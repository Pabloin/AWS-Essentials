locals {
  common_tags = {
    Terraform   = "true"
    Project     = var.project_name
    Environment = var.environment
  }
  tags = merge(local.common_tags, var.default_tags)
}
