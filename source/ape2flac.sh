#!/bin/sh

### ape2flac
# Converts APE to FLAC
#
# Version 1 (2???-??-??)
# - Requires: ffmpeg

which rev || exit 1

infile="$*"
base=$(echo "$infile" | rev | cut -d. -f2- | rev)
outfile="$base".flac

test -f "$infile" || exit 2

ffmpeg -i "$infile" "$outfile" && rm "$infile"
