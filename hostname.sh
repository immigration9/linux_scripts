#!/bin/bash
HOSTNAME=$1
echo $HOSTNAME >/etc/hostname
echo "127.0.1.1 $HOSTNAME" >>/etc/hosts
hostname -F /etc/hostname
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
sudo apt-get install -y language-pack-ko