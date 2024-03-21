#!/bin/bash
# camformat
# version 1

# Color del texto:
BLACKFG='\033[0;30m'
REDFG='\033[0;31m'
GREENFG='\033[0;32m'
YELLOWFG='\033[0;33m'
BLUEFG='\033[0;34m'
PINKFG='\033[0;35m'
CYANFG='\033[0;36m'
WHITEFG='\033[0;37m'

# Color de fondo:
BLACKBG='\033[0;40m'
REDBG='\033[0;41m'
GREENBG='\033[0;42m'
YELLOWBG='\033[0;43m'
BLUEBG='\033[0;44m'
PINKBG='\033[0;45m'
CYANBG='\033[0;46m'
WHITEBG='\033[0;47m'

# Efectos de texto:
BOLD='\033[1m'
UNDERLINE='\033[4m'
REVERSE='\033[7m'
RESET='\033[0m'
NC='\033[0m' # No Color

function help
{
    cat <<EOF
camformat: Format file names of camera photos.
Reformat file names deleting spaces and converting to lowercase. Additionally
you can set a prefix string to cut (commonly: IMG_), or rename to timestamp
extracted from exif tag if available.

Usage:   exportcam [-d DIRECTORY] [-g PREFIX] [-n] [-v] [-h]

Basic options:
 -d <directory>    Set the directory where operate. Defaults: current
 -p <prefix>       Set the prefix string to cut. Defaults: none
 -t                Use EXIF Original date tag for filename. This anulates -p
 -n                Dry run
 -h                Show this help
EOF
}


function error
{
    #printf "${RED}${*}${NC}\n"
    >&2 echo -e "${REDFG}Error:${NC} $*"
    exit 1
}

function info
{
    >&2 echo -e "${YELLOWFG}Info:${NC} $*"
}

function dryrun
{
    >&2 echo -e "${GREENFG}(dryrun)${NC} $*"
}

function mygetts
{
    export LANG=C
    exiv2 "$*" | grep '^Image timestamp'| cut -d: -f2- | tr -d : |
    awk '{print $1"_"$2}'
}

while getopts 'hntd:p:' opt
do
    case $opt in
        d) directory="$OPTARG";;
        p) prefix="$OPTARG";;
        n) dryrun=0;;
        t) tag=0;;
        h) help; exit 0;;
        \?) error "Unknown option: -$opt";;
        :) error "Missing option argument for -$opt";;
        *) error "Unimplemented option: -$opt";;
    esac
done

# Test -n validates '' string
test -z "$directory" || cd "$directory" 2> /dev/null ||
error "Can't change to directory: $directory"

for i in "$prefix"*.{jxl,jpg,jpeg,heif,png,avif,webp,mp4,mkv,JXL,JPG,JPEG,HEIF,PNG,AVIF,WEBP,MP4,MKV}
do
    test -f "$i" || continue

    if [ "$tag" ]
    then
        filetype=$(file -bi $i | cut -d\; -f1)

        if [ "$filetype" = "image/jpeg" ]
        then
            newname=$(mygetts "$i").jpg
        elif [ "$filetype" = "image/jxl" ]
        then
            newname=$(mygetts "$i").jxl
        elif [ "$filetype" = "image/avif" ]
        then
            newname=$(mygetts "$i").avif
        elif [ "$filetype" = "image/heic" ]
        then
            newname=$(mygetts "$i").heif
        else
            info "($i) Can't read EXIF from this file format: $filetype"
            continue
        fi
    else
        test -z "$prefix" &&
        newname=$(echo "$i" | tr ' ' _ | tr '[:upper:]' '[:lower:]' | sed s/_-_/-/g) ||
        newname=$(echo "$i" | sed s/^$prefix//g | tr ' ' _ | tr '[:upper:]' '[:lower:]' | sed s/_-_/-/g)
    fi

    test -z "$newname" && continue
    test "$i" = "$newname" && continue

    if [ "$dryrun" ]
    then
        dryrun mv -iv "$i" "$newname"
    else
        mv -nv "$i" "$newname" && continue ||
        i_sum=$(md5sum "$i" | cut -b-32)
        newname_sum=$(md5sum "$newname" | cut -b-32)

        if [ "$i_sum" = "$newname_sum" ]
        then
            info "Files $i and $newname are identical."
            info "Deleted: $i"
            rm "$i"
        else
            info "Failed to move $i to $newname. File exists."
            echo "$i_sum $i"
            echo "$newname_sum $newname"
            # Ask for confirmation:
            mv -iv "$i" "$newname"
        fi
    fi
done

