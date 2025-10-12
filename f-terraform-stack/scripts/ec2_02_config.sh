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

## Step 2 - Gen SSH for Git configuration
echo "Generating SSH key for GitHub..."
ssh-keygen -t ed25519 -f ~/.ssh/github_key -C "pablo.ezequiel.inchausti@gmail.com"

# Add key to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_key

# Configure SSH to use this key for GitHub
cat <<SSH_CONFIG >> ~/.ssh/config
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_key
SSH_CONFIG

echo ""
echo "============================================================"
echo "📋 IMPORTANT: Add this public key to your GitHub account"
echo "   Go to: https://github.com/settings/keys"
echo "   Click: 'New SSH key'"
echo "   Title: 'Bastion Host Key'"
echo "============================================================"
echo ""
cat ~/.ssh/github_key.pub
echo ""
echo "============================================================"
echo "⏸️  Press Enter after you've added the key to GitHub..."
read -p ""


## Step 3 - Scripts for this EC2 Configuration
mkdir -p ~/repos/
echo "Cloning repository from GitHub..."
git clone git@github.com:Pabloin/AWS-Essentials.git  ~/repos/Pabloin/AWS-Essentials

cd ~/repos/Pabloin/AWS-Essentials

git config user.name  pabloin
git config user.email pablo.ezequiel.inchausti@gmail.com
cd ~/


cp ~/repos/Pabloin/AWS-Essentials/f-terraform-stack/scripts/.bash_profile ~/

cat <<EOF >> ~/.bashrc

# Load .bash_profile if it exists
if [ -f ~/.bash_profile ]; then
      . ~/.bash_profile
fi

EOF

cd ~/
source .bashrc

