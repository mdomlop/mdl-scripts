#!/bin/sh

##### estacion
# Devuelve la estación del año.
#
# Version 1 (Mucho antes de 2024-03-21)
# - Requires: nothing special

test -z $1 && S0=$(date '+%m%d') || S0=$1

S1=0321
S2=0621
S3=0923
S4=1222

if test $S0 -gt $S1 &&  test $S0 -lt $S2
then
echo primavera && exit 0

elif test $S0 -gt $S2 &&  test $S0 -lt $S3
then
echo verano && exit 0

elif test $S0 -gt $S3 &&  test $S0 -lt $S4
then echo otoño && exit 0

else
echo invierno
fi
