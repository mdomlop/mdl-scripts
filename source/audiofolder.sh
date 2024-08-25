#!/bin/sh

##### audiofolder
# Rename folder by tag in a flac flacfile
#
# Version 1.1 (2024-08-25)
# - More legible format:
# Version 1 (2023-??-??)
# - Requires: mediainfo, opusinfo, vorbiscomment

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

albumdir=$(echo $@ | tr -d '/')
test -z "$albumdir" && exit 1

fullfile=$@
test -z "$fullfile" && echo "No se encuentra el archivo \"$fullfile\"" && exit 1

format=$(mediainfo "$fullfile" | grep -m1 'Format\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )

albumartist=$(mediainfo "$fullfile" | grep 'Album/Performer\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
artist=$(mediainfo "$fullfile" | grep 'Album/Performer\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
originalyear=$(mediainfo "$fullfile" | grep 'ORIGINALYEAR\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
date=$(mediainfo "$fullfile" | grep 'Recorded date\s*:'| sed 's/.*:\s*//' | sed s+/+~+g | cut -d- -f1 )
album=$(mediainfo "$fullfile" | grep 'Album\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
subtitle=$(mediainfo "$fullfile" | grep 'SUBTITLE\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
media=$(mediainfo "$fullfile" | grep 'MEDIA\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
disctotal=$(mediainfo "$fullfile" | grep 'Part/Total\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
label=$(mediainfo "$fullfile" | grep 'Label\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
catalognumber=$(mediainfo "$fullfile" | grep 'CATALOGNUMBER\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
releasecountry=$(mediainfo "$fullfile" | grep 'RELEASECOUNTRY\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )

if [ "$format" = "FLAC" ]
then
	echo "Format detected: $format"
	#albumartist: Artist(s) primarily credited on the release.
	albumartist=$(metaflac --export-tags-to=- "$fullfile" | grep '^ALBUMARTIST=' | cut -d= -f2)
	date=$(metaflac --export-tags-to=- "$fullfile" | grep '^DATE=' | cut -d= -f2 | cut -d- -f1)
	originalyear=$(metaflac --export-tags-to=- "$fullfile" | grep '^ORIGINALYEAR=' | cut -d= -f2)
	album=$(metaflac --export-tags-to=- "$fullfile" | grep '^ALBUM=' | cut -d= -f2)
	subtitle=$(metaflac --export-tags-to=- "$fullfile" | grep '^SUBTITLE=' | cut -d= -f2)
	media=$(metaflac --export-tags-to=- "$fullfile" | grep '^MEDIA=' | cut -d= -f2)
	disctotal=$(metaflac --export-tags-to=- "$fullfile" | grep '^TOTALDISCS=' | cut -d= -f2)
	label=$(metaflac --export-tags-to=- "$fullfile" | grep '^LABEL=' | cut -d= -f2)
	catalognumber=$(metaflac --export-tags-to=- "$fullfile" | grep '^CATALOGNUMBER=' | cut -d= -f2)
	releasecountry=$(metaflac --export-tags-to=- "$fullfile" | grep '^RELEASECOUNTRY=' | cut -d= -f2)
elif [ "$format" = "Opus" ]
then
	echo "Format detected: $format"
	#albumartist: Artist(s) primarily credited on the release.
	albumartist=$(opusinfo "$fullfile" | grep '^ALBUMARTIST=' | cut -d= -f2)
	date=$(opusinfo "$fullfile" | grep '^DATE=' | cut -d= -f2 | cut -d- -f1)
	originalyear=$(opusinfo "$fullfile" | grep '^ORIGINALYEAR=' | cut -d= -f2)
	album=$(opusinfo "$fullfile" | grep '^ALBUM=' | cut -d= -f2)
	subtitle=$(opusinfo "$fullfile" | grep '^SUBTITLE=' | cut -d= -f2)
	media=$(opusinfo "$fullfile" | grep '^MEDIA=' | cut -d= -f2)
	disctotal=$(opusinfo "$fullfile" | grep '^TOTALDISCS=' | cut -d= -f2)
	label=$(opusinfo "$fullfile" | grep '^LABEL=' | cut -d= -f2)
	catalognumber=$(opusinfo "$fullfile" | grep '^CATALOGNUMBER=' | cut -d= -f2)
	releasecountry=$(opusinfo "$fullfile" | grep '^RELEASECOUNTRY=' | cut -d= -f2)
elif [ "$format" = "Ogg" ]
then
	echo "Format detected: $format"
	#albumartist: Artist(s) primarily credited on the release.
	albumartist=$(vorbiscomment -l "$fullfile" | grep '^ALBUMARTIST=' | cut -d= -f2)
	date=$(vorbiscomment -l "$fullfile" | grep '^DATE=' | cut -d= -f2 | cut -d- -f1)
	originalyear=$(vorbiscomment -l "$fullfile" | grep '^ORIGINALYEAR=' | cut -d= -f2)
	album=$(vorbiscomment -l "$fullfile" | grep '^ALBUM=' | cut -d= -f2)
	subtitle=$(vorbiscomment -l "$fullfile" | grep '^SUBTITLE=' | cut -d= -f2)
	media=$(vorbiscomment -l "$fullfile" | grep '^MEDIA=' | cut -d= -f2)
	disctotal=$(vorbiscomment -l "$fullfile" | grep '^TOTALDISCS=' | cut -d= -f2)
	label=$(vorbiscomment -l "$fullfile" | grep '^LABEL=' | cut -d= -f2)
	catalognumber=$(vorbiscomment -l "$fullfile" | grep '^CATALOGNUMBER=' | cut -d= -f2)
	releasecountry=$(vorbiscomment -l "$fullfile" | grep '^RELEASECOUNTRY=' | cut -d= -f2)
elif [ "$format" = "MPEG Audio" ]
then
	echo "Format detected: $format"
	date=$(mediainfo "$fullfile" | grep 'Recorded date\s*:'| sed 's/.*:\s*//' | sed s+/+~+g | cut -d- -f1 )
	media=$(mediainfo "$fullfile" | grep 'Media Type\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
	label=$(mediainfo "$fullfile" | grep 'Publisher\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
	releasecountry=$(mediainfo "$fullfile" | grep 'MusicBrainz Album Release Country\s*:'| sed 's/.*:\s*//' | sed s+/+~+g )
else
	printf "${RED}Unknow format:${NC} $format\n"
	echo "Exiting..."
	exit 1
fi

if [ -n "$originalyear" ] && [ -n "$date" ]
then
	if [ "$originalyear" -eq "$date" ]
	then
		year="$originalyear"
	else
		year="$originalyear, $date"
	fi
elif [ -n "$originalyear" ]
then
		year="$originalyear"
elif [ -n "$date" ]
then
		year="$date"
fi


if [ -n "$subtitle" ]
then
	album="$album _$subtitle"_
fi

#echo ------------------------------------------------------------
#echo "originalyear: $originalyear"
#echo "date: $date"
#echo "album: $album"
#echo "subtitle: $subtitle"
#echo "albumartist: $albumartist"
#echo "media: $media"
#echo "disctotal: $disctotal"
#echo "label: $label"
#echo "catalognumber: $catalognumber"
#echo "releasecountry: $releasecountry"
#echo ------------------------------------------------------------

rval=0

if [ -z "$year" ]
then
	printf "${RED}Faltan las etiquetas originalyear y date${NC}\n"
	rval=$(($rval + 1))
fi
if [ -z "$album" ]
then
	printf "${RED}Falta la etiqueta album${NC}\n"
	rval=$(($rval + 1))
fi
if [ -z "$albumartist" ]
then
	printf "${RED}Falta la etiqueta albumartist${NC}\n"
	rval=$(($rval + 1))
fi
if [ -z "$media" ]
then
	printf "${RED}Falta la etiqueta media${NC}\n"
	rval=$(($rval + 1))
fi
if [ -z "$disctotal" ]
then
	printf "${RED}Falta la etiqueta totaldisc${NC}\n"
	rval=$(($rval + 1))
fi
if [ -z "$label" ]
then
	printf "${RED}Falta la etiqueta label${NC}\n"
	rval=$(($rval + 1))
fi
if [ -z "$catalognumber" ]
then
	printf "${RED}Falta la etiqueta catalognumber${NC}\n"
	rval=$(($rval + 1))
fi
if [ -z "$releasecountry" ]
then
	printf "${RED}Falta la etiqueta releasecountry${NC}\n"
	rval=$(($rval + 1))
fi

test $rval -gt 0 && exit 1

foldername1=$(echo "$year - $album ($albumartist) [$media x$disctotal] $label [$catalognumber] $releasecountry" | tr '/' '~' | tr ':' '_' | tr '\n' ' ' | awk '{$1=$1;print}')
foldername2=$(echo "$year - $album ($artist) [$media x$disctotal] $label [$catalognumber] $releasecountry" | tr '/' '~' | tr ':' '_' | tr '\n' ' ' | awk '{$1=$1;print}')


#printf "${GREEN}* New album is:${NC}\n"

if [ "$foldername1" = "$foldername2" ]
then
	echo "$foldername1"
else
	echo "$foldername1"
	echo "$foldername2"
fi
