#!/bin/bash

zenity --question --title='Install BakeUp' --text="Would you really like to install BakeUp?"
if [ "$?" != "0" ]; then
	exit
fi

rm -R bakeup-master/
wget "https://github.com/dari-ta/bakeup/archive/master.zip"
unzip master.zip
bakeup-master/setup
rm -R bakeup-master/
rm master.zip

# Infinity Control Center Module
gksudo mkdir -p /opt/infinity/icontrolm/bakeup/
gksudo echo "BakeUp,security-high,/opt/bakeup/bakeup," >/opt/infinity/icontrolm/bakeup/info

