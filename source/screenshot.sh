#!/bin/sh

### screenshot
# Simple screencapture tool.
#
# Version 1 (2024-03-16)
# - Requires: imagemagick, gwenview

directory="$HOME/Documentos/Imágenes/Capturas"
name="$HOSTNAME-$(date +%Y.%m.%d-%A-%H.%M.%S)"
format="png"

image="$directory"/"$name"."$format"
viewer="gwenview"

mkdir -p "$directory" &&
import -window root "$image" &&
gwenview "$image"

