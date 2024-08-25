#!/bin/sh

REDBG='\033[0;41m'
NC='\033[0m' # No Color
BOLD='\033[1m'
ERROR="[${REDFG}ERROR${NC}]"

user=$(id -nu)
static="firefox-static-$user"
volatile="/dev/shm/firefox-volatile-$user"

cd /home/$user/.mozilla/ || exit 1

error ()
{
    >&2 printf "$ERROR ${BOLD}$*${NC}\n"
    exit 1
}

opterror ()
{
    >&2 printf "$ERROR $* ${BOLD}$mycmd${NC}\n"
}

check ()
{
	test -d "$static" || error "$static is not a directory"
	ln -sfT "$volatile" firefox || error "I can't create firefox link"
}

start ()
{
	check
	test -d "$volatile" ||
	cp -a "$static" "$volatile" || exit 1
}

stop ()
{
	test -d "$volatile" || exit 0
	rsync -a --delete "$volatile"/ "$static"/ && rm -r "$volatile"
}

mycmd="$1"
case "$mycmd" in
	start) start;;
	stop) stop;;
	:)  opterror "Missing option argument for";;
	*)  opterror "Unimplemented option:";;
esac
