#!/bin/bash
# Simple script to deploy your custom script to bastion and run it
# Usage: ./deploy-and-run.sh

set -e

# Get bastion IP from terraform
cd ../envs/dev
BASTION_IP=$(terraform output -raw bastion_public_ip)
cd ../../scripts

echo "Bastion IP: $BASTION_IP"
echo "Deploying ec2_01_install.sh..."

# Copy script to bastion
scp -i ~/.ssh/bastion-key \
    -o StrictHostKeyChecking=no \
    ec2_01_install.sh \
    ubuntu@${BASTION_IP}:/tmp/

echo "Running script on bastion..."

# Run the script
ssh -i ~/.ssh/bastion-key \
    -o StrictHostKeyChecking=no \
    ubuntu@${BASTION_IP} \
    "sudo bash /tmp/ec2_01_install.sh"

echo "Done!"
