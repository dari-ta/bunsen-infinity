#!/bin/bash

	zenity --question --title "Sublime Text 2 installation" --text "This script will install Sublime Text 2 trial on your computer"
	if [ $? = 1 ]; then
		exit 0
	fi

	cd /home/$USER
    
    STDOWNLOADURLLIKE="http://c758482.r82.cf2.rackcdn.com/Sublime Text "
	#Busquemos la ultima version de Sublime Text 2 en la web directamente
	STURLTOCHECK="`wget -qO- http://www.sublimetext.com/2`"
	#Home del usuario (http://stackoverflow.com/questions/7358611/bash-get-users-home-directory-when-they-run-a-script-as-root)
	USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
	echo -e "\e[7m*** Sublime Text 2 Batch Installer/Upgrader (esteban@attitude.cl)\e[0m"
	#URL distinta segun sistema 64 o 32 bits
	if [ "i686" = `uname -m` ]; then
	#http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.tar.bz2
	echo -e "\e[7m*** System x86 detected.\e[0m"
	#URLS="`grep -Po '(?<=href=").*?(?=">)' <<<"$STURLTOCHECK"`"
	URL="`grep -Po '(?<=href="http://c758482.r82.cf2.rackcdn.com/Sublime Text )(.*?)([^x64].tar.bz2)(?=">)' <<<"$STURLTOCHECK"`"
	elif [ "x86_64" = `uname -m` ]; then
	#http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1%20x64.tar.bz2
	echo -e "\e[7m*** System x86_64 detected.\e[0m"
	URL="`grep -Po '(?<=href="http://c758482.r82.cf2.rackcdn.com/Sublime Text )(.*?)(\w+ x64.tar.bz2)(?=">)' <<<"$STURLTOCHECK"`"
	fi
	#El nombre del archivo y la URL completa, la necesitamos para despues
	THEFILE="Sublime Text $URL"
	THEDOWNLOADURL="$STDOWNLOADURLLIKE$URL"
	echo -e "\e[7m*** I will download and install $THEDOWNLOADURL for you :)\e[0m"
	#Instalamos Sublime Text 2
	echo -e "\e[7m*** Creating temp location on /var/cache/...\e[0m"
	#A la flash-installer
	APT_PROXIES=$(apt-config shell http_proxy Acquire::http::Proxy https_proxy Acquire::https::Proxy ftp_proxy Acquire::ftp::Proxy)
	if [ -n "$APT_PROXIES" ]; then
	eval export $APT_PROXIES
	fi
	#Descargamos
	echo -e "\e[7m*** Downloading file to temp location...\e[0m"
	#http://unix.stackexchange.com/questions/37507/what-does-do-here
	:> wgetrc
	echo "noclobber = off" >> wgetrc
	echo "dir_prefix = ." >> wgetrc
	echo "dirstruct = off" >> wgetrc
	echo "verbose = on" >> wgetrc
	echo "progress = bar:default" >> wgetrc
	echo "tries = 3" >> wgetrc
	WGETRC=wgetrc wget --continue -O "$THEFILE" "$THEDOWNLOADURL" \
	|| echo -e "\e[7m***Download failed.\e[0m"
	
	#WGETRC=wgetrc wget --continue -o "$THEFILE" "$THEDOWNLOADURL" | \
    #         sed -u 's/^.* \+\([0-9]\+%\) \+\([0-9.]\+[GMKB]\) \+\([0-9hms.]\+\).*$/\1\n# Downloading... \2 (\3)/' | \
    #         zenity --progress --title='Installing Sublime Text 2' --auto-kill --auto-close
	
	rm -f wgetrc
	
	#rename binary
	if [ -f "Sublime Text 2.0.2.tar.bz2" ]; then
		mv "Sublime Text 2.0.2.tar.bz2" /home/$USER/sublime_text.tar.bz2
	fi
    sleep 1s

    #extract binary
    tar -xf sublime_text.tar.bz2
    #delete binary
    rm sublime_text.tar.bz2

	#Install icon
	gksudo cp "/home/$USER/Sublime Text 2/Icon/128x128/sublime_text.png" /usr/share/icons/hicolor/128x128/apps/
	gksudo update-icon-caches /usr/share/icons/hicolor

#    /home/$USER/.infinity/startmenu-default EDITOR "Sublime Text 2" "\"/home/$USER/Sublime Text 2/sublime_text\""
	/opt/infinity/startmenu/startmenu-add "Sublime Text 2" "\"/home/$USER/Sublime Text 2/sublime_text\"" "sublime_text"
    
    zenity --info --title="Sublime Text 2 installation" --text "The installation was successfull"
    
    x-www-browser http://www.sublimetext.com &

exit 0
