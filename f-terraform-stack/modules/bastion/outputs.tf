output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_eip.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = aws_instance.bastion.private_ip
}

output "bastion_public_dns" {
  description = "Public DNS of the bastion host"
  value       = aws_instance.bastion.public_dns
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = aws_instance.bastion.id
}

output "security_group_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "ssh_key_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.bastion.key_name
}

output "ssh_command" {
  description = "SSH command to connect to bastion"
  value       = "ssh -i ~/.ssh/bastion-key ubuntu@${aws_eip.bastion.public_ip}"
}

output "ami_id" {
  description = "AMI ID used for the bastion instance"
  value       = local.ami_id
}

output "ami_name" {
  description = "AMI name used for the bastion instance (if auto-detected)"
  value       = var.ami_id == "" ? data.aws_ami.ubuntu[0].name : "Custom AMI"
}
