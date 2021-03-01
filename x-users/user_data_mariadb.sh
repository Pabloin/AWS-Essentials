#!/bin/bash
yum update -y

yum install -y mariadb-server

sudo systemctl enable mariadb
sudo systemctl start mariadb 

# To validate
# mysql -u root -p

# To make the installation secure
# mysql_secure_installation

# TODO: Validar ... 