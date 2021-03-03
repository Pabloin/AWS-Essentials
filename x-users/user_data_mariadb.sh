#!/bin/bash
yum update -y

yum install -y mariadb-server

systemctl enable mariadb
systemctl start mariadb 


MY_DATABASE='myDb'
MY_DATABASE_USER='myUser'
MY_DATABASE_PASS='myPass'
#MY_HOST=localhost
MY_HOST='%'

commands="CREATE DATABASE \`${MY_DATABASE}\`; \
CREATE USER '${MY_DATABASE_USER}'@'${MY_HOST}' IDENTIFIED BY '${MY_DATABASE_PASS}'; \
GRANT USAGE ON *.* TO '${MY_DATABASE_USER}'@'${MY_HOST}' IDENTIFIED BY '${MY_DATABASE_PASS}'; \
GRANT ALL privileges ON \`${MY_DATABASE}\`.* TO '${MY_DATABASE_USER}'@'${MY_HOST}'; \
FLUSH PRIVILEGES; \
"



echo "${commands}" | /usr/bin/mysql -u root -p

# To validate
# mysql -u root -p

# To make the installation secure
# mysql_secure_installation

# MariaDB Ok!s

# Nota ... si decimos en AMAZON EC2: 
#      $ sudo yum install -y mysql 
# nos instala mariadb.x86


# Para crear un usuario de demo, con acceso remoto:


# mysql> GRANT ALL PRIVILEGES ON * . * TO 'pabloin'@'%' WITH GRANT OPTION; \

# mysql> FLUSH PRIVILEGES; \

# y 
# vim  /etc/my.cnf
# 
# [mysqld]
# bind-address = 0.0.0.0
