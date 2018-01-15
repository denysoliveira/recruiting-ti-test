#!/bin/bash
yum update -y
yum install nginx perl libaio perl-Data-Dumper.x86_64 -y
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
cd /usr/local
wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.38-linux-glibc2.12-x86_64.tar.gz
tar zxvf /usr/local/mysql-5.6.38-linux-glibc2.12-x86_64.tar.gz
ln -s /usr/local/mysql-5.6.38-linux-glibc2.12-x86_64 mysql
cd mysql
scripts/mysql_install_db --user=mysql
bin/mysqld_safe --user=mysql &
cp support-files/mysql.server /etc/init.d/mysql.server
ls /usr/local/mysql/bin/ > arquivosbin
let a=`cat arquivosbin | wc | cut -c6-7`
cont=1
let b="$a+1"
         while [  $cont -lt $b ]; do
                ln -s /usr/local/mysql/bin/`cat arquivosbin | sed -n "$cont"p` /bin/
             let cont=cont+1 
         done
/etc/init.d/mysql.server start
mysql -e "CREATE DATABASE cinema"
mysql cinema < /tmp/database.sql
mysql -e "GRANT SELECT ON cinema.* TO ''@'localhost';"
mysql -e "flush privileges"

#php fpm
yum -y install git gcc gcc-c++ libxml2-devel pkgconfig openssl-devel bzip2-devel curl-devel libpng-devel libjpeg-devel 
yum -y install libXpm-devel freetype-devel gmp-devel libmcrypt-devel mariadb-devel aspell-devel recode-devel libpqxx-devel
yum -y install autoconf bison re2c libicu-devel libwebp-devel wget unzip net-tools libc-client-devel libpng12-devel
yum -y install libxslt-devel

# Install PHP 7.1
yum -y install php71 php71-gd php71-imap php71-mbstring php71-mysqlnd php71-opcache php71-pdo php71-pecl-apcu php71-fpm 

mv /tmp/index.php /usr/share/nginx/html/index.php
mv /tmp/ping.php /usr/share/nginx/html/ping.php
mv /usr/share/nginx/html/index.htlm /usr/share/nginx/html/index.orig
sudo /etc/init.d/nginx start
sudo /etc/init.d/php-fpm start

echo "Sucesso!"
