#!/bin/bash

URL="$1"
EXTENSION="${URL##*.}"

rm ./instscript

wget -O "instscript" "$URL" | \
         sed -u 's/^.* \+\([0-9]\+%\) \+\([0-9.]\+[GMKB]\) \+\([0-9hms.]\+\).*$/\1\n# Downloading... \2 (\3)/' | \
         zenity --progress --title='Downloading installer' --auto-kill --auto-close

if [ "$EXTENSION" = "gz" ];then
	mkdir instscript_dir
	tar -xzf instscript -C instscript_dir/
	chmod u+x ./instscript_dir/setup
	cd ./instscript_dir
	./setup
	cd ..
	rm -R ./instscript_dir
else
	chmod u+x ./instscript
	./instscript
fi


rm ./instscript

exit 0
