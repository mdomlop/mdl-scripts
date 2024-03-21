#!/bin/sh

directory="$HOME/Documentos/Imágenes/Capturas"
name="$HOSTNAME-$(date +%Y.%m.%d-%A-%H.%M.%S)"
format="png"

image="$directory"/"$name"."$format"
viewer="gwenview"

mkdir -p "$directory" &&
import -window root "$image" &&
gwenview "$image"

