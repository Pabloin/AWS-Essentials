#!/bin/bash
yum update -y
yum install httpd -y
yum install git -y
service httpd start
chkconfig httpd on

# Hello World web Site

cd /var/www/html
echo "Hello!" > index.html


# Static web Site

git clone https://github.com/Pabloin/AWS-Essentials.git

cp -r AWS-Essentials/GameDay/game-day-site/* /var/www/html/


# Dynamic web Site

sudo apt-get install php

echo "<?php echo '<p>Hello World</p>'; ?>" > /var/www/html/index.php


