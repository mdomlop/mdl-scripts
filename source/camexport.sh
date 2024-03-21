#!/bin/bash

### camexport
# Move formated photo files to album directory by date.
#
# Version 1 (2023-03-21)
# - Requires: nothing special

defconfigfile=~/.config/exportcam


function help
{
    cat <<EOF
Usage:   exportcam [-c configfile [-a outdir] [-i inputdir] [-n] [-v] [-h]

Basic options:
 -c <configfile>   Use alternative configuration file
 -o <outdir>       Output directory for files
 -i <inputdir>     Set the directory where operate. Defaults: current
 -n                Dry run
 -h                Show this help
EOF
}


function error
{
    >&2 echo $*
    exit 1
}

while getopts 'hnvc:o:i:' opt
do
    case $opt in
        c) configfile="$OPTARG";;
        o) outdir="$OPTARG";;
        i) inputdir="$OPTARG";;
        n) dryrun=0;;
        v) verbose=0;;
        h) help; exit 0;;
        \?) error "Unknown option: -$opt";;
        :)  error "Missing option argument for -$opt";;
        *)  error "Unimplemented option: -$opt";;
    esac
done

test -z "$XDG_CONFIG_HOME" || XDG_CONFIG_HOME=$HOME/.config

test -z "$configfile" && configfile=$XDG_CONFIG_HOME/exportcam

#test -f "$configfile" && . "$configfile"
test -f "$configfile" || error "Config file not exists: $configfile" && eval $(grep -E ^config_outdir= "$configfile")

if [ -z "$inputdir" ]
then
    test -f "$configfile" ||
    error "Not inputdir and Config file not exists ($configfile)"

    eval $(grep -E ^config_inputdir= "$configfile")
    test -z "$config_inputdir" || inputdir="$config_inputdir"
    inputdir=$(pwd)
fi

if [ -z "$outdir" ]
then
    test -f "$configfile" ||
    error "Not outdir and Config file not exists: $configfile"

    eval $(grep -E ^config_outdir= "$configfile")
    test -z "$config_outdir" || outdir="$config_outdir"

fi

test -d "$inputdir" || error "Input directory not exits: ($inputdir)"
cd "$inputdir" || error "Can't change to directory: $inputdir"

test -d "$outdir" || error "Output directory not exits ($outdir)"


for i in ????????_?*.{jxl,jpg,jpeg,heif,png,webp,mp4,mkv,JXL,JPG,JPEG,HEIF,PNG,WEBP,MP4,MKV}
do
    if [ ! -f "$i" ]
    then
        # Avoid ????????_?*.mkv file not found et al.
        test -n "$verbose" && echo No file: $i
        continue
    fi

    year=$(echo $i | cut -c1-4)
    month=$(echo $i | cut -c5-6)

    case $month in
        01) month='01-enero';;
        02) month='02-febrero';;
        03) month='03-marzo';;
        04) month='04-abril';;
        05) month='05-mayo';;
        06) month='06-junio';;
        07) month='07-julio';;
        08) month='08-agosto';;
        09) month='09-septiembre';;
        10) month='10-octubre';;
        11) month='11-noviembre';;
        12) month='12-diciembre';;
        *) error "Error in file: $i ($n) Error to process month: $month";;
    esac

    savedir="$outdir/$year/$month"

    if [ -z "$dryrun" ]
    then
        mkdir -pv "$savedir" &&
        mv -iv "$i" "$savedir/" || echo "Failed to move $i to $savedir/$n"
    else
        echo "(dryrun) mkdir -pv \"$savedir\"" &&
        echo "(dryrun) mv -iv \"$i\" \"$savedir/\""
    fi

done

