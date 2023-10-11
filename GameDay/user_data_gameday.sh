#!/bin/bash
yum update -y
yum install httpd -y
yum install git -y
yum install php -y
service httpd start
chkconfig httpd on

#------------------------
echo "Hello Static Site!"  > /var/www/html/index.html

#------------------------
echo "<?php echo '<p>Hello PHP World</p>'; ?>" > /var/www/html/index.php

#------------------------
# Static web Site

git clone https://github.com/Pabloin/AWS-Essentials.git

cp -r AWS-Essentials/GameDay/game-day-site/* /var/www/html/

