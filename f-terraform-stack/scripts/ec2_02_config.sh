#!/bin/bash

# EC2 {Personal} Configuration
## This script is for {Personal} configuration the EC2 instance

cat <<EOF
# EC2 Configuration
      - Step 1 - Configure AWS Credential
      - Step 2 - Gen SSH fors Git configuration
      - Step 3 - Scripts for this EC2 Configuration
EOF


## Step 1 - Configure AWS Credential
aws configure

## Step 2 - Gen SSH fors Git configuration
ssh-keygen


## Step 3 - Scripts for this EC2 Configuration
mkdir -p ~/repos/
git clone git@github.com:Pabloin/AWS-Essentials.git  ~/repos/Pabloin/AWS-Essentials

cd ~/repos/Pabloin/AWS-Essentials

git config user.name  pabloin
git config user.email pablo.ezequiel.inchausti@gmail.com
cd ~/

cp ~/repos/Pabloin/AWS-Essentials/.config/ec2_bastion/.bash_profile ~/

cat <<EOF >> ~/.bashrc

# Load .bash_profile if it exists
if [ -f ~/.bash_profile ]; then
      . ~/.bash_profile
fi

EOF

cd ~/
source .bashrc

