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
BLINK='\033[5m'
RESET='\033[0m'

KO="[${REDFG}${BOLD}KO${RESET}]"
OK="[${GREENFG}${BOLD}OK${RESET}]"
WARNING="[${YELLOWFG}${BOLD}WARNING${RESET}]"
INFO="[${CYANFG}${BOLD}INFO${RESET}]"

umask 0022

DEVICE=$1
ADDRESS=$2
BROADCAST=$3
ROUTE=$4
DNS1=$5
DNS2=$6

DEF_DEVICE='mbnet0'
DEF_ADDRESS='192.168.1.10/24'
DEF_BROADCAST='192.168.1.255'
DEF_ROUTE='192.168.1.1'
DEF_DNS1='1.1.1.1'
DEF_DNS2='1.0.0.1'

MYHOST=$(cat /etc/hostname)

testrun ()
{
	msg=$1

	if test $? = 0
	then
		printf "$OK $msg\n"
	else
		printf "$KO $msg\n"
		exit 1
	fi
}

case $MYHOST in
	metatron)
		testrun "Host is metatron"
		DEF_ADDRESS='192.168.1.10/24'
		;;
	pctv)
		testrun "Host is pctv"
		DEF_ADDRESS='192.168.1.2/24'
		;;
	*)
		printf "$WARNING Unknown host: $MYHOST\n"
		printf "You may set ADDRESS variable to something like '192.168.x.x'\n"
		exit 1
		;;
esac


test -z "$DEVICE"    && DEVICE=$DEF_DEVICE
test -z "$ADDRESS"   && ADDRESS=$DEF_ADDRESS
test -z "$BROADCAST" && BROADCAST=$DEF_BROADCAST
test -z "$ROUTE"     && ROUTE=$DEF_ROUTE
test -z "$DNS1"      && DNS1=$DEF_DNS1
test -z "$DNS2"      && DNS2=$DEF_DNS2

if test ! -e /sys/class/net/$DEVICE
then
	interfaces=$(ls -1 /sys/class/net/ | tr '\n' ' ')
	printf "$KO Selected network interface does not exist: ${REDFG}${BOLD}$DEVICE${RESET}\n"
	printf "$INFO Available interfaces are: ${YELLOWFG}${BOLD}$interfaces${RESET}\n"
	exit 1
fi

ip addr flush dev $DEVICE; testrun "Flush device $DEVICE"

ip address add $ADDRESS brd $BROADCAST dev $DEVICE; testrun "Link address to $ADDRESS"

ip link set dev $DEVICE up; testrun "Link up $DEVICE"

ip route add default via $ROUTE dev $DEVICE; testrun "Route $DEVICE via $ROUTE"

echo nameserver $DNS1 >  /etc/resolv.conf; testrun "DNS1 setted to $DNS1"
echo nameserver $DNS2 >> /etc/resolv.conf; testrun "DNS2 setted to $DNS2"

ping -qc1 $DNS1 > /dev/null; testrun "Ping to DNS $DNS1"
ping -qc1 www.google.com > /dev/null; testrun "Ping to Google"
