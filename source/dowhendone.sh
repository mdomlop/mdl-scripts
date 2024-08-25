#!/bin/sh

#### Sentinel
# Do action when trigger up.
#
# Version 1 (2024-03-22)
# - Requires: POSIX shell

pid=$1
shift
action=$@

echo PID $pid
echo ACTION $action

while test -d /proc/$pid
do
    sleep 1

done

$action
