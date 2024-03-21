#!/bin/sh

### music2mobile
# Copy my music to my mobile.
#
# Version 1 (2024-03-??)
# - Requires: opusenc

folderalbum="$@"

encoder=opusenc
encargs='--quiet --vbr --bitrate 192 --comp 10 --expect-loss 0'
outputdir=/var/tmp/mdl/Movil
outputdir="$outputdir"/"$folderalbum"

if [ -d "$folderalbum"/Tracks ]
then
	mkdir -p "$outputdir"
else
	echo Tracks dir not found.
exit 1
fi

#ls "$folderalbum"/Tracks/*.flac |
#echo parallel "$encoder" $encargs {} "$outputdir"/{/.}.ogg

for i in "$folderalbum"/Tracks/*.flac
do
	"$encoder" $encargs "$i" "$outputdir/$(basename "$i" .flac).ogg"
done
