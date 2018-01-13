#!/bin/bash
yum update
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

#!/bin/bash

#php fpm
yum -y install git gcc gcc-c++ libxml2-devel pkgconfig openssl-devel bzip2-devel curl-devel libpng-devel libjpeg-devel 
yum -y install libXpm-devel freetype-devel gmp-devel libmcrypt-devel mariadb-devel aspell-devel recode-devel libpqxx-devel
yum -y install autoconf bison re2c libicu-devel libwebp-devel wget unzip net-tools libc-client-devel libpng12-devel
yum -y install libxslt-devel


mkdir -p /opt/php-7.1
mkdir -p /usr/local/src/php7-build
cd /usr/local/src/php7-build
wget http://br1.php.net/get/php-7.1.0.tar.bz2/from/this/mirror -O php-7.1.0.tar.bz2
tar jxf php-7.1.0.tar.bz2
cd php-7.1.0/

./configure --prefix=/opt/php-7.1 --with-zlib-dir --with-freetype-dir --enable-mbstring \
--with-libxml-dir=/usr --enable-soap --enable-intl --enable-calendar --with-curl --with-mcrypt --with-zlib \
--with-gd --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets \
--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash \
--enable-zip --with-pcre-regex --with-pdo-mysql --with-mysqli --with-mysql-sock=/var/lib/mysql/mysql.sock \
--with-xpm-dir=/usr --with-webp-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf \
--with-openssl --with-fpm-user=nginx --with-fpm-group=nginx --with-libdir=lib64 --enable-ftp --with-imap \
--with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --enable-opcache --enable-fpm

make
make install
ln -s /opt/php-7.1/ /usr/local/src/php7-build/php-7.1.0/
#mkdir -p /opt/php-7.1/etc/php-fpm.d/
cp /usr/local/src/php7-build/php-7.1.0/php.ini-production /opt/php-7.1/lib/php.ini
cp /opt/php-7.1/etc/php-fpm.conf.default /opt/php-7.1/etc/php-fpm.conf
cp /opt/php-7.1/etc/php-fpm.d/www.conf.default /opt/php-7.1/etc/php-fpm.d/www.conf


## Mudar ini do PHP
for i in /opt/php-7.*/lib/php.ini;do
sed -i 's|max_execution_time = 30|max_execution_time = 120|' $i
sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 32M|' $i
sed -i 's|post_max_size = 8M|post_max_size = 32M|' $i
sed -i 's|error_reporting = E_ALL & ~E_DEPRECATED|error_reporting =  E_ERROR|' $i
sed -i 's|short_open_tag = Off|short_open_tag = On|' $i
sed -i "s|;date.timezone =|date.timezone = 'America\/Sao_Paulo'|" $i
done


echo 'zend_extension=opcache.so' >> /opt/php-7.1/lib/php.ini

### Change PHP-FPM Config
sed -i "s|;pid = run/php-fpm.pid|pid = run/php-fpm.pid|" /opt/php-7.1/etc/php-fpm.conf
#sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:8999|" /opt/php-7.1/etc/php-fpm.d/www.conf
sed -i "s|;include=etc/fpm.d/\*.conf|include=/opt/php-7.1/etc/php-fpm.d/\*.conf|" /opt/php-7.1/etc/php-fpm.conf

