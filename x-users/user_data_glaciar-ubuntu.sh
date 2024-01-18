#!/bin/bash
apt update -y
apt install apache2 -y
apt install git -y
apt install unzip -y
service apache2 start

systemctl status apache2
systemctl enable apache2.service

cd /var/www/html
echo "Hello!" > index.html

git clone https://github.com/Pabloin/AWS-Essentials.git
unzip AWS-Essentials/c-site-glaciar/lab-02/site-glaciar-lab-02.zip
cp -r lab-02/site/* /var/www/html/

# User Data Ubuntu


# Install Extra utiles
# AWS-Cli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm awscliv2.zip


