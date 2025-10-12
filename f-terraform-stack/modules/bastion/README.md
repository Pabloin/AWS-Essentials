# Bastion Module

This module creates a secure bastion host (jump server) for SSH access to private resources.

## Resources Created

- Security Group with SSH access control
- SSH Key Pair
- EC2 Instance (Ubuntu 24.04 LTS)
- Elastic IP (static public IP)
- Automatic Ubuntu 24.04 AMI lookup

## Features

- ✅ **Ubuntu 24.04 LTS** - Latest long-term support version
- ✅ **Elastic IP** - Persistent public IP address
- ✅ **Customizable security** - Control SSH access via CIDR blocks
- ✅ **User data support** - Custom initialization scripts
- ✅ **Configurable instance type** - Default t3.micro (Free Tier eligible)
- ✅ **GP3 volumes** - Modern, cost-effective storage

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Project name for resource naming | string | - | yes |
| vpc_id | ID of the VPC | string | - | yes |
| subnet_id | ID of the public subnet | string | - | yes |
| ssh_public_key | SSH public key content | string | - | yes |
| allowed_ssh_cidr | CIDR blocks for SSH access | list(string) | - | yes |
| instance_type | EC2 instance type | string | t3.micro | no |
| root_volume_size | Root volume size in GB | number | 20 | no |
| user_data_script | User data for initialization | string | "" | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_public_ip | Public IP address (Elastic IP) |
| bastion_private_ip | Private IP address |
| bastion_public_dns | Public DNS name |
| bastion_instance_id | EC2 instance ID |
| security_group_id | Security group ID |
| ssh_key_name | SSH key pair name |
| ssh_command | Ready-to-use SSH command |
| ami_id | AMI ID used |
| ami_name | AMI name used |

## Usage

### Basic Usage

```terraform
module "bastion" {
  source = "./modules/bastion"

  project_name      = "my-project"
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.public_subnet_id
  ssh_public_key    = var.ssh_public_key
  allowed_ssh_cidr  = ["203.0.113.0/32"]
}
```

### Advanced Usage

```terraform
module "bastion" {
  source = "./modules/bastion"

  project_name      = "my-project"
  vpc_id            = module.networking.vpc_id
  subnet_id         = module.networking.public_subnet_id
  ssh_public_key    = var.ssh_public_key
  allowed_ssh_cidr  = ["203.0.113.0/32", "198.51.100.0/24"]
  
  # Custom configuration
  instance_type     = "t3.small"
  root_volume_size  = 30
  user_data_script  = file("${path.module}/scripts/init.sh")
}
```

### Complete Example with Networking

```terraform
module "networking" {
  source = "./modules/networking"

  project_name       = "production"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "bastion" {
  source = "./modules/bastion"

  project_name     = "production"
  vpc_id           = module.networking.vpc_id
  subnet_id        = module.networking.public_subnet_id
  ssh_public_key   = file("~/.ssh/id_ed25519.pub")
  allowed_ssh_cidr = ["YOUR.IP.HERE/32"]
}

output "connect_command" {
  value = module.bastion.ssh_command
}
```

## Security Considerations

### ⚠️ Important Security Notes

1. **Restrict SSH Access**
   ```terraform
   # ❌ BAD: Open to the world
   allowed_ssh_cidr = ["0.0.0.0/0"]
   
   # ✅ GOOD: Restrict to your IP
   allowed_ssh_cidr = ["203.0.113.25/32"]
   ```

2. **Use Strong Keys**
   ```bash
   # Generate Ed25519 key (recommended)
   ssh-keygen -t ed25519 -f ~/.ssh/bastion-key
   
   # Or RSA 4096
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/bastion-key
   ```

3. **Regular Updates**
   - Ubuntu 24.04 includes unattended-upgrades
   - Monitor and patch regularly
   - Consider AWS Systems Manager Session Manager

4. **Principle of Least Privilege**
   - Bastion should only have SSH access
   - No unnecessary software installed
   - Minimal IAM permissions

## Connecting to the Bastion

After deployment:

```bash
# Direct connection
ssh -i ~/.ssh/bastion-key ubuntu@<PUBLIC_IP>

# Or use the output command
terraform output -raw ssh_command
```

## Using as Jump Host

To access private resources through the bastion:

```bash
# SSH tunnel
ssh -i ~/.ssh/bastion-key -L 3306:private-db.local:3306 ubuntu@<BASTION_IP>

# ProxyJump (modern approach)
ssh -J ubuntu@<BASTION_IP> ubuntu@<PRIVATE_IP>

# ProxyCommand (older approach)
ssh -o ProxyCommand="ssh -W %h:%p ubuntu@<BASTION_IP>" ubuntu@<PRIVATE_IP>
```

## Monitoring

The bastion includes:
- CloudWatch Logs (via user_data_script)
- Instance status checks
- System status checks

Add monitoring with:

```terraform
resource "aws_cloudwatch_metric_alarm" "bastion_status" {
  alarm_name          = "${var.project_name}-bastion-status"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  
  dimensions = {
    InstanceId = module.bastion.bastion_instance_id
  }
}
```

## Cost Estimate

Monthly costs (us-east-1):
- **t3.micro**: ~$7.50/month (Free Tier: 750 hours/month)
- **Elastic IP**: Free (when attached)
- **GP3 20GB**: ~$1.60/month
- **Data Transfer**: Variable

**Total**: ~$9/month (or FREE with AWS Free Tier)

## Alternatives to Consider

- **AWS Systems Manager Session Manager** - No SSH, no public IP needed
- **AWS Client VPN** - Full VPN access to VPC
- **AWS Transit Gateway** - Connect multiple VPCs
- **Tailscale/ZeroTier** - Modern VPN mesh networks

## Troubleshooting

### Cannot connect via SSH

1. **Check security group**
   ```bash
   aws ec2 describe-security-groups --group-ids <SG_ID>
   ```

2. **Verify your IP**
   ```bash
   curl ifconfig.me
   ```

3. **Check instance status**
   ```bash
   aws ec2 describe-instance-status --instance-ids <INSTANCE_ID>
   ```

4. **Test connectivity**
   ```bash
   telnet <BASTION_IP> 22
   ```

### SSH key issues

```bash
# Verify key permissions
chmod 600 ~/.ssh/bastion-key

# Test with verbose output
ssh -vvv -i ~/.ssh/bastion-key ubuntu@<BASTION_IP>
```
