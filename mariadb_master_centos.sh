#!/bin/bash

## Environment Variable for Master Host
MASTER_HOST=$1

## Setup directory for MySQL
mkdir /home/data/mysql -p
cd /var/lib
ln -s /home/data/mysql (= ln -s /home/data/mysql /var/lib/mysql)

## Install MariaDB 10.0
apt-get update
apt-get install python-software-properties
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xcbcb082a1bb943db
add-apt-repository 'deb http://ftp.kaist.ac.kr/mariadb/repo/10.0/ubuntu precise main'
apt-get update
apt-get install mariadb-server

## Setup mysqladmin & shutdown
mysqladmin -u root -p1qaz@WSX shutdown
cd /var/lib/mysql
rm ib_logfile?

## Create specific directory for mysql log
mkdir /home/log/ -p
cd /var/log
mv mysql /home/log/
ln -s /home/log/mysql/
chmod -R +x /home/log/

## Install WhaTap Conf file for MariaDB
cd /etc/mysql/conf.d
wget http://whatap.hbox.a3c.co.kr/db%2Fmariadb.cnf -O whatap.cnf

## Master Host Setup
master_log_file=`echo "show master status"| mysql -u repl -p1qaz@WSX -h $MASTER_HOST -N | awk '{print $1}'`
master_log_pos=`echo "show master status"| mysql -u repl -p1qaz@WSX -h $MASTER_HOST -N | awk '{print $2}'`
echo "CHANGE MASTER TO MASTER_HOST='"$MASTER_HOST"', MASTER_USER='repl', MASTER_PASSWORD='1qaz@WSX', MASTER_LOG_FILE='"$master_log_file"', MASTER_LOG_POS=$master_log_pos"|mysql
echo "start slave"|mysql
