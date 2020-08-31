#!/bin/bash

# This script checks current ip and sends info to a gmail email account.
# Also requires a working config in /etc/ssmtp/ssmtp.conf "https://www.havetheknowhow.com/Configure-the-server/Install-ssmtp.html"

if [ -e /usr/sbin/ssmtp ] ;then
echo
else echo "Installing ssmtp"
sudo apt install ssmtp -y
fi

if [ -e /usr/bin/iostat ] ;then
echo
else echo "Installing iostat"
sudo apt install sysstat -y
fi

if [ -e /usr/bin/curl ] ;then
echo
else echo "Installing curl"
sudo apt install curl -y
fi

wanip=$(curl ifconfig.me)
if [ ! -f ~/code/wanip.txt ] ;then
mkdir -p ~/code
echo $wanip > ~/code/wanip.txt
exit
fi

lastwanip=$(cat ~/code/wanip.txt)
if [ "$wanip" = "$lastwanip" ] ;then
exit
fi

if [ "$wanip" != "$lastwanip" ] ;then
echo "Subject: IP has changed to $wanip" > ~/code/stats.txt
uptime -s && uptime -p >> ~/code/stats.txt
iostat device sda --human >> ~/code/stats.txt
sendmail "put ur email here without quotes" < ~/code/stats.txt
echo $wanip > ~/code/wanip.txt
fi
