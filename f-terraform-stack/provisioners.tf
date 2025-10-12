# This file contains provisioners to run scripts after bastion deployment
# This is an alternative to manually running deploy-and-run.sh

# Run custom script on bastion after creation
resource "null_resource" "configure_bastion" {
  count = var.run_custom_setup ? 1 : 0
  
  # Trigger re-run if bastion instance changes
  triggers = {
    instance_id = module.bastion.bastion_instance_id
  }

  # Wait for instance to be ready
  depends_on = [module.bastion]

  # Copy script to bastion
  provisioner "local-exec" {
    command = <<-EOT
      sleep 30
      scp -i ~/.ssh/bastion-key \
          -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          ${path.module}/scripts/ec2_01_install.sh \
          ubuntu@${module.bastion.bastion_public_ip}:/tmp/
    EOT
  }

  # Run script on bastion
  provisioner "local-exec" {
    command = <<-EOT
      ssh -i ~/.ssh/bastion-key \
          -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          ubuntu@${module.bastion.bastion_public_ip} \
          "sudo bash /tmp/ec2_01_install.sh"
    EOT
  }
}

# Alternative: Run via SSM (no SSH required)
resource "null_resource" "configure_bastion_ssm" {
  count = 0  # Set to 1 to enable, 0 to disable
  
  triggers = {
    instance_id = module.bastion.bastion_instance_id
  }

  depends_on = [module.bastion]

  provisioner "local-exec" {
    command = <<-EOT
      sleep 60
      aws ssm send-command \
          --instance-ids ${module.bastion.bastion_instance_id} \
          --document-name "AWS-RunShellScript" \
          --parameters 'commands=["sudo bash /home/ubuntu/ec2_01_install.sh"]'
    EOT
  }
}
