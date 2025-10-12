#!/bin/bash

# EC2 Installation
## This script installs the necessary tools for managing # AWS EKS clusters on an EC2 instance.

cat <<EOF
      - Step 1 - Install awscli, tree
      - Step 2 - Install kubctl, eksctl
      - Step 3 - Install Helm
      - Step 4 - Install k9s
      - Step 5 - Varidate installation
EOF

# Step 0 - Configure SSH settings
sudo sed -i \
  -e '/^#*ClientAliveInterval/d' \
  -e '/^#*ClientAliveCountMax/d' \
  -e '$aClientAliveInterval 300' \
  -e '$aClientAliveCountMax 12' \
  /etc/ssh/sshd_config

sudo systemctl daemon-reload
sudo systemctl restart ssh

# Step 1 - Install awscli, tree

sudo apt update
sudo apt install tree -y
sudo apt install net-tools -y
sudo apt install nfs-common -y
sudo apt install zip unzip  -y
sudo apt install fzf -y



sudo apt update
sudo apt install unzip -y 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
rm    awscliv2.zip
sudo ./aws/install
aws --version


# Install terraform
sudo apt install -y gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y
terraform -install-autocomplete
terraform -version


# Step 2 - Install kubctl, eksctl
VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

## Optional for kubectl automplete
sudo apt install bash-completion -y
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source ~/.bashrc


## eksctl: for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
eksctl

# Step 3 - Install Helm (deprecated method)
# curl https://baltocdn.com/helm/signing.asc -o /tmp/helm-signing.asc
# sudo gpg --dearmor -o /usr/share/keyrings/helm.gpg /tmp/helm-signing.asc
# echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# sudo apt update

# sudo apt install helm -y
# helm version


# Step 3 - Install Helm (new method)
sudo rm -f /etc/apt/sources.list.d/helm-stable-debian.list
sudo rm -f /usr/share/keyrings/helm.gpg
sudo apt-get update
sudo apt-get install -y curl gpg apt-transport-https

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
  | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" \
  | sudo tee /etc/apt/sources.list.d/helm-debian.list

sudo apt-get update
sudo apt-get install -y helm

helm version




# Step 4 - Install k9s
# k9s is a terminal-based UI to interact with your Kubernetes clusters.
curl -LO https://github.com/derailed/k9s/releases/download/v0.32.4/k9s_Linux_amd64.tar.gz
tar -xzf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
rm k9s_Linux_amd64.tar.gz


# Step 5 - Varidate installation
aws --version
kubectl version --client
eksctl version
helm version


# Step 6 - Install Docker Compose

##  1. Update the system and prerequisites
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release

## 2. Add Docker’s official GPG key and repo
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## 3. Install Docker Engine   
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

## 4. Add your user to the docker group (Optional)
sudo usermod -aG docker $USER
newgrp docker


## 5. Verify Docker and Compose are working
sudo docker version
sudo docker run hello-world
docker version
docker compose version

docker version --format '{{.Server.Version}}'
docker compose version --short

docker run hello-world


## Note:
# kubectl can work also on local machine, but you need to configure it to connect to the EKS cluster.
# You can do this by running:
# aws eks --region us-east-2 update-kubeconfig --name Liferay-eks-cluster

