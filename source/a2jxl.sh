#!/bin/sh

### a2jxl
# Convierte cualquier archivo admitido por cjxl a jxl con el máximo esfuerzo.
#
# Version 1 (2024-03-21)
# - Requires: cjxl

# Si el formato de entrada es jpg la conversión es sin pérdida y se podría
# recuperar el jpeg original con djxl.
#
#
# Si quieres usar múltiples hilos con parallel:
#   find -name *.png *.PNG *.jpg *.JPG *.jpeg *.JPEG -type f | parallel -j 16 a2jxl '{}'
# o:
#   parallel --ungroup -j16 -v -q -a /tmp/files cjxl -e 9 --num_threads=0 --lossless_jpeg=1 -d 0 "{}" "{.}.jxl"

args=$@
echo
du -h "$args"
base=$(echo "$args" | rev | cut -d. -f2- | rev)
#cjxl "$args" "$base".jxl -d 0 -e 9 -j 1 --num_threads=0 && rm "$1"
cjxl "$args" "$base".jxl -d 0 -e 9 -j 1 --num_threads=0 --quiet && rm "$1"
#echo -n ">>> "
#du -h "$base".jxl
