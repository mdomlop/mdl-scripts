#!/bin/sh

##### 2x265
# Convert h.264 to h.265 (no change in resolution)
#
# Version 1 (2023-??-??)
# - Requires: ffmpeg

# https://www.tauceti.blog/posts/linux-ffmpeg-amd-5700xt-hardware-video-encoding-hevc-h265-vaapi/

input=$1
container=$2
test -z "$container" && container=mkv

originalcontainer=$(echo "$input" | rev | cut -d '.' -f1 | rev)
test "$container" = "$originalcontainer" && container=x265."$container"

outputname=$(basename "$input" ."$originalcontainer")

output="$outputname"."$container"



ffmpeg -i "$input" -c:v libx265 -vtag hvc1 -c:a copy "$output"

#ffmpeg -vaapi_device /dev/dri/renderD129 -i "$input" -vf 'format=nv12,hwupload'  -map 0:0  -c:v hevc_vaapi  -map 0:a -c:a copy -rc_mode CQP  -global_quality 25 -profile:v main  -v verbose "$output"
