NEW_HOSTNAME="whatapdata01"
OLD_HOSTNAME=$HOSTNAME
HOSTNAME=$NEW_HOSTNAME
hostname $HOSTNAME
sed -i "s/$OLD_HOSTNAME/$HOSTNAME/" /etc/hostname 2> /dev/null
sed -i "s/HOSTNAME=$OLD_HOSTNAME/HOSTNAME=$HOSTNAME/" /etc/sysconfig/network 2> /dev/null
echo "\$HOSTNAME=$HOSTNAME"
grep -Hn '' /proc/sys/kernel/hostname
grep -Hn '' /etc/hostname 2> /dev/null
grep -Hn '' /etc/sysconfig/network 2> /dev/null