#!/bin/bash
yum update -y
yum install httpd -y
yum install git -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "Hello!" > index.html
