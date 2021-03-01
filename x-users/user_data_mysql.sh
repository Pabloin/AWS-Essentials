#!/bin/bash
yum update -y


sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum install -y mysql-community-server


sudo systemctl enable mysqld
sudo systemctl start mysqld

# To validate
# - get the temporary password with:

# sudo grep 'temporary password'  /var/log/mysqld.log
# mysql -u root -p

# To make the installation secure
# mysql_secure_installation
