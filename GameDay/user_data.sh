#!/bin/bash
yum update -y
yum install httpd -y
yum install git -y
service httpd start
chkconfig httpd on

cd /var/www/html
echo "Hello!" > index.html

git clone https://github.com/Pabloin/AWS-Essentials.git
unzip AWS-Essentials/GameDay/game-day-site.zip
cp -r game-day-site/* /var/www/html/

