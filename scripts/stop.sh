#!/bin/bash

# USAGE:
# ./stop.sh {APP_NAME}

if [ $# -eq 0 ];then
  PID_FILE="tmp/pids/unicorn.pid"
else
  PID_FILE="tmp/pids/unicorn-$1.pid"
fi

printf "Attempting to kill existing unicorn process..."
if [ -f $PID_FILE ];then
  kill -QUIT `cat $PID_FILE`
  rm -rf $PID_FILE
  echo "killed"
else
  echo "none found."
fi
