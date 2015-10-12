#!/bin/bash

URL="http://dan-net.de/infinity/dwl/softdir-data"

rm /home/$USER/.infinity/softdir-data-new

wget -O "/home/$USER/.infinity/softdir-data-new" "$URL" | \
         sed -u 's/^.* \+\([0-9]\+%\) \+\([0-9.]\+[GMKB]\) \+\([0-9hms.]\+\).*$/\1\n# Downloading... \2 (\3)/' | \
         zenity --progress --title='Downloading new Data' --auto-kill --auto-close

cp /home/$USER/.infinity/softdir-data-new /home/$USER/.infinity/softdir-data
rm /home/$USER/.infinity/softdir-data-new

exit 0