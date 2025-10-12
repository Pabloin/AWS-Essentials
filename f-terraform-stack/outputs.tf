output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = module.bastion.bastion_private_ip
}

output "bastion_public_dns" {
  description = "Public DNS of the bastion host"
  value       = module.bastion.bastion_public_dns
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = module.bastion.bastion_instance_id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.networking.public_subnet_id
}

output "availability_zone" {
  description = "Availability zone of the public subnet"
  value       = module.networking.availability_zone
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = module.bastion.security_group_id
}

output "ssh_command" {
  description = "SSH command to connect to bastion"
  value       = module.bastion.ssh_command
}

output "ami_id" {
  description = "AMI ID used for the bastion instance"
  value       = module.bastion.ami_id
}

output "ami_name" {
  description = "AMI name used for the bastion instance"
  value       = module.bastion.ami_name
}
