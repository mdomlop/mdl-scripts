#!/bin/sh
# Convierte heif/heic a jpg. Si la conversón es exitosa el archivo
# original será borrado.
# La conversión es con pérdida.
#
# Si quieres usar múltiples hilos con parallel:
#   find <location> -name *.heif -type f | parallel -j 16 heif2jpg '{}'
# o:
#   parallel --ungroup -j16 -v -q -a /tmp/files cjxl -e 9 --num_threads=0 --lossless_jpeg=1 -d 0 "{}" "{.}.jxl"

args=$@
base=$(echo "$args" | rev | cut -d. -f2- | rev)

if [ -z "$args" ]
then
	echo "Sorry. I need two arguments."
	echo "Usage:"
	echo "    $0 <file.heif> <outfile.jpg>"
	exit 1
fi

if [ "$args" = "$base".jpg ]
then
	echo "This will never be run!"
	exit 2
fi

if [ -f "$args" ]
then
	heif-convert "$args" "$base".jpg &&
	rm "$args"
else 
	echo "File not found!" 
	exit 3
fi
