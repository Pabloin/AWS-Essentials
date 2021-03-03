#!/bin/bash
yum update -y

yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-community-server

systemctl enable mysqld
systemctl start mysqld

# To validate
# - get the temporary password with:

# sudo grep 'temporary password'  /var/log/mysqld.log
# mysql -u root -p

# To make the installation secure
# mysql_secure_installation
