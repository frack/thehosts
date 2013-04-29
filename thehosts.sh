#!/bin/sh
#
# Frack TheHosts WOL and PowerOff Cronjob.
#
# Shell script to be fired from Cron. This script checks the space-state and if
# the space is open, it will WakeUp the TheHosts machine. If the space is
# closed and the server is still running, it will shut down the machine.
#
# Add the following line to crontab -e:
# 5 *   * * *   /root/thehosts.sh > /dev/null 2>&1
#
# More information: http://frack.nl/wiki/TheHosts
#

SPACEURL='http://frack.nl/spacestate/status.txt'
THEHOSTS_MAC='00:08:02:11:4f:22'
THEHOSTS_IP='192.168.1.202'
SPACEROOT='/root/.ssh/space-root'

STATE=`wget -q -O - $SPACEURL`
if [ $STATE -eq 1 ]
then
  /usr/sbin/etherwake -i eth1 $THEHOSTS_MAC
fi

if [ $STATE -eq 0 ]
then
  /bin/ping -c 2 $THEHOSTS_IP > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    /usr/bin/ssh -q -i $SPACEROOT $THEHOSTS_IP '/sbin/halt -p'
  fi
fi
