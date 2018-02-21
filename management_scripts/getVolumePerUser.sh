#!/bin/bash

SETSIZE=10
# Examining volume in MB units
EXMB=`expr $SETSIZE`

for name in $(cut -d: -f1,3 /etc/passwd | awk -F: '$2 > 499 {print $1}')
# Categorize only the accounts which has an UID higher than 500
do
  echo "User $name: File which has passed ${SETSIZE}mb & it's volume"
  find /usr /tmp /home -user $name -type f -ls | awk "\$7 > $EXMB" | awk '{print "Directory: " $11, "/ Storage: " $7}'
  # Compare & Print the files which UIDs with higher than 500 obtains within the designated directory
  echo ""
done
exit
