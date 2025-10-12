# Networking Module

This module creates the basic networking infrastructure for the bastion stack.

## Resources Created

- VPC with DNS support
- Internet Gateway
- Public Subnet
- Route Table with internet access
- Route Table Association

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| project_name | Project name for resource naming | string | yes |
| vpc_cidr | CIDR block for VPC | string | yes |
| public_subnet_cidr | CIDR block for public subnet | string | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr | CIDR block of the VPC |
| public_subnet_id | ID of the public subnet |
| public_subnet_cidr | CIDR block of the public subnet |
| internet_gateway_id | ID of the Internet Gateway |
| availability_zone | Availability zone of the public subnet |

## Usage

```terraform
module "networking" {
  source = "./modules/networking"

  project_name       = "my-project"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}
```
