#!/bin/bash
set -e

# Update system packages
apt-get update
apt-get upgrade -y

# Install essential tools
apt-get install -y \
    curl \
    wget \
    vim \
    git \
    htop \
    net-tools \
    unzip \
    jq \
    awscli

# Configure timezone
timedatectl set-timezone UTC

# Enable automatic security updates
apt-get install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

# Create a welcome message
cat > /etc/motd << 'EOF'
╔═══════════════════════════════════════╗
║     Welcome to Bastion Host           ║
║     Ubuntu 24.04 LTS                  ║
╚═══════════════════════════════════════╝

This is a bastion host for secure access to your AWS resources.

System Information:
EOF

# Add hostname to motd
echo "  Hostname: $(hostname)" >> /etc/motd
echo "  Date: $(date)" >> /etc/motd

# Log completion
echo "User data script completed successfully at $(date)" >> /var/log/user-data.log
