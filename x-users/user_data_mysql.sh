#!/bin/bash
yum update -y

yum install -y mysql

sudo systemctl enable mysql
sudo systemctl start mysql 

# To validate
# mysql -u root -p

# To make the installation secure
# mysql_secure_installation
