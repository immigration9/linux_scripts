#!/bin/bash
## WhaTap Infra Installer for CentOS/RHEL
## Created date: 2017-11-22

LICENSE_KEY=$1
HOST_SERVER=$2

install_infra() {
    sudo rpm --import http://repo.whatap.io/centos/release.gpg
    sudo rpm -Uvh http://repo.whatap.io/centos/5/noarch/whatap-repo-1.0-1.noarch.rpm
    sudo yum install -y whatap-infra
}

enter_license() {
    echo "license=${LICENSE_KEY}" |sudo tee /usr/whatap/infra/conf/whatap.conf
    echo "whatap.server.host=${HOST_SERVER}" |sudo tee -a /usr/whatap/infra/conf/whatap.conf
    echo "createdtime=`date +%s%N`" |sudo tee -a /usr/whatap/infra/conf/whatap.conf
}

start_agent() {
    sudo service whatap-infra restart
}

manual() {
    echo "Manual - WhaTap Install Infra"
    echo "$0 {LICENSE_KEY} {HOST_SERVER}"
    echo "ex) ${0} x3343443t-3434343 210.122.38.123/210.122.38.124"
}

if [ $# -eq 2 ];
then
    install_infra
    enter_license
    start_agent
else
    manual
    exit
fi
