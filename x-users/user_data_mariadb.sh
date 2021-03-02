#!/bin/bash
yum update -y

yum install -y mariadb-server

systemctl enable mariadb
systemctl start mariadb 

# To validate
# mysql -u root -p

# To make the installation secure
# mysql_secure_installation

# MariaDB Ok!s

# Nota ... si decimos en AMAZON EC2: 
#      $ sudo yum install -y mysql 
# nos instala mariadb.x86