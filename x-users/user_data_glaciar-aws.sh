#!/bin/bash
yum update -y
yum install httpd -y
yum install git -y
yum install tmux -y

service httpd start
chkconfig httpd on

cd /var/www/html
echo "Hello!" > index.html

git clone https://github.com/Pabloin/AWS-Essentials.git
unzip AWS-Essentials/c-site-glaciar/lab-02/site-glaciar-lab-02.zip
cp -r lab-02/site/* /var/www/html/

# Amazon Linux 2

