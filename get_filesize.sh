#!/bin/bash

PROJECT_LIST=~/project_list.log
RESULT_SET=~/result_set.log
PCODE_DIGITS=4
READ_DATE=$1

if [ $# -eq 0 ] ; then
    echo '=================================================='
    echo 'Please type in desired date in yyyyMMdd format'
    echo 'ex) 20170820'
    echo '=================================================='
    exit 0
fi

if [ -f $PROJECT_LIST ]; then rm $PROJECT_LIST; fi
if [ -f $RESULT_SET ]; then rm $RESULT_SET; fi

sudo find /wpm/javam/server/yardbase -regextype sed -regex ".*/[0-9]\{$PCODE_DIGITS\}" -type d > $PROJECT_LIST

while read project; do
  agents_list=`sudo find $project/$READ_DATE/* -type d`
  for agent in $agents_list; do
    current_result=`ls -al $agent | grep profile.tim | awk '{print $5}'`
    if [ -n "$current_result" ]; then
      echo ${agent}','${current_result} >> $RESULT_SET
    fi
  done
done < $PROJECT_LIST