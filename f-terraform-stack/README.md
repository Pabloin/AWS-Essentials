# Terraform Stack - Bastion Host on Ubuntu 24.04

This Terraform stack deploys a secure bastion host running Ubuntu 24.04 LTS on AWS.

## Architecture

The stack creates:
- VPC with custom CIDR block
- Public subnet with Internet Gateway
- Security Group with SSH access
- Ubuntu 24.04 LTS EC2 instance (bastion host)
- Elastic IP for the bastion host
- SSH key pair for secure access

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform >= 1.0 installed
3. SSH key pair generated

## Setup Instructions

### 1. Generate SSH Key (if you don't have one)

```bash
# On Linux/Mac or Windows with OpenSSH
# Using Ed25519 (modern, faster, more secure)
ssh-keygen -t ed25519 -f ~/.ssh/moreno-stack-bastion-key -C "moreno-stack-bastion-key"

```

**Note:** Ed25519 is recommended for modern systems (OpenSSH 6.5+, 2014). It provides better security with smaller key sizes and faster performance.

### 2. Configure Variables

Copy the example variables file and update it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set:
- `ssh_public_key`: Your SSH public key content
- `allowed_ssh_cidr`: Your IP address (get it from https://ipinfo.io/ip)
- Other variables as needed

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan Deployment

```bash
terraform plan
```

### 5. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm.

## Connecting to the Bastion

After deployment, connect using:

```bash
ssh -i ~/.ssh/bastion-key ubuntu@<BASTION_IP>
```

The bastion IP will be shown in the Terraform outputs.

## Outputs

- `bastion_public_ip`: Public IP address of the bastion
- `bastion_public_dns`: Public DNS name
- `bastion_instance_id`: EC2 instance ID
- `vpc_id`: VPC ID
- `public_subnet_id`: Public subnet ID
- `security_group_id`: Security group ID
- `ssh_command`: Ready-to-use SSH command

## Security Considerations

⚠️ **IMPORTANT**: 
- Always restrict `allowed_ssh_cidr` to your specific IP address
- Never commit `terraform.tfvars` with sensitive data to version control
- Use IAM roles and policies following the principle of least privilege
- Regularly update the bastion host with security patches
- Consider using AWS Systems Manager Session Manager as an alternative to SSH

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Customization

You can customize the following variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | us-east-1 |
| `project_name` | Project name prefix | bastion-stack |
| `environment` | Environment name | dev |
| `vpc_cidr` | VPC CIDR block | 10.0.0.0/16 |
| `public_subnet_cidr` | Public subnet CIDR | 10.0.1.0/24 |
| `instance_type` | EC2 instance type | t3.micro |
| `allowed_ssh_cidr` | Allowed SSH CIDR blocks | 0.0.0.0/0 |
| `ssh_public_key` | SSH public key | (required) |

## Cost Estimate

Approximate monthly costs (us-east-1):
- t3.micro instance: ~$7.50/month
- Elastic IP: Free (when attached to running instance)
- Data transfer: Variable based on usage

## Troubleshooting

### Cannot connect via SSH
- Verify security group allows your IP
- Check that the instance is running
- Ensure you're using the correct SSH key
- Verify the Elastic IP is attached

### Terraform errors
- Run `terraform init` to update providers
- Check AWS credentials are configured
- Verify you have the necessary IAM permissions

## License

See the LICENSE file in the repository root.
