#!/bin/bash

stime=90
ami=`whoami`

if [ "$ami" != "root" ]; then
  echo "This program is limited only for the System Administrator (root)."
  exit
fi

echo "Pausing user account: $1. Proceeding with Steps A to D"
echo ""
echo "A: Please change the password of account $1"
echo ""
passwd $1

tty=`who | grep $1 | tail -1 | awk '{print $2}'`
cat << "EOF" > /dev/$tty
**********************************************
< Warning >
The account you have been using will be terminated
within 90 seconds by the System Administrator.

Please finish your work and log out beforehand.

Any questions regarding the extended use of this account,
Please inquire the System Management team.

Email: system@whatap.io
***********************************************
EOF

  sleep $stime
  killall -s HUP -u $1
  sleep 1
  killall -s KILL -u $1
echo "B: Every process run by $1 has been terminated"
echo "C: Account $1 has been logged out"
echo "                      $(date)"

chmod 000 /home/$1
echo "D: Account $1 has been paused"
exit