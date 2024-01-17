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

