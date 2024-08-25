#!/bin/sh

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

KO="[${REDFG}KO${NC}]"
OK="[${GREENFG}OK${NC}]"

function testrun
{
	msg=$1

	if test $? = 0
	then
		echo -e "$OK $msg"
	else
		echo -e "$KO $msg"
		exit 1
	fi
}

DEVICE=$1
DEF_DEVICE='mbnet0'

test -z "$DEVICE" && DEVICE=$DEF_DEVICE

if test ! -e /sys/class/net/$DEVICE
then
	interfaces=$(ls -1 /sys/class/net/ | tr '\n' ' ')
	printf "$KO Selected network interface does not exist: ${REDFG}${BOLD}$DEVICE${RESET}\n"
	printf "$INFO Available interfaces are: ${YELLOWFG}${BOLD}$interfaces${RESET}\n"
	exit 1
fi

ip addr flush dev $DEVICE; testrun "Flush device $DEVICE"

rm /etc/resolv.conf; testrun "Remove /etc/resolv.conf"
