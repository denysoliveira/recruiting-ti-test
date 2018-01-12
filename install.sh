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
cp support-files/mysql.server /etc/init.d/mysqld
/etc/init.d/mysqld start
ls /usr/local/mysql/bin/ > arquivosbin
let a=`cat arquivosbin | wc | cut -c6-7`
cont=1
let b="$a+1"
         while [  $cont -lt $b ]; do
                ln -s /usr/local/mysql/bin/`cat arquivosbin | sed -n "$cont"p` /bin/
             let cont=cont+1 
         done

exit

