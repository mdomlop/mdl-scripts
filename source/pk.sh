#!/bin/sh

# pk
# A wrapper for some package managers.
#
# Version 1.1 (2024-07-13)
#
#   - confirm_com function.
#   - Return values.
#
# Version 1 (2024-06-16)
# - Requires: -

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

OK="[${GREENFG}OK${NC}]"
KO="[${REDFG}KO${NC}]"
ERROR="[${REDFG}ERROR${NC}]"
QUESTION="[${PINKFG}QUESTION${NC}]"
DISTRO="[${PINKFG}DISTRO${NC}]"

cmd_add="nocom add"
cmd_merge="nocom merge"
cmd_remove="nocom remove"
cmd_purge="nocom purge"
cmd_sync="nocom sync"
cmd_upgrade="nocom upgrade"
cmd_search="nocom search"
cmd_list="nocom list"
cmd_belongs="nocom belongs"
cmd_info="nocom info"

RETVAL=0

help ()
{
    cat <<EOF
pkg: A wrapper for some package managers.
A simpler wrapper for common package managers commands of many distros.

Usage:   pkg [add|merge|remove|purge|sync|upgrade|search|list|belongs|info|help] [package1 package2 ...]

Basic options:
 add     <package>  Add (install) <package> to the system.
 merge   <package>  Merge (install) local <package> into the system.
 remove  <package>  Remove installed <package>.
 purge   <package>  Purge installed <package>.
 sync               Syncronizes system with repository.
 upgrade            Upgrades installed packages.
 search  <package>  Search and show status of <package>.
 list    <package>  Show files in <package>.
 belongs <file>     Show package that owns a <file>.
 info    <package>  Show information of a <package>.
 help               Show this help.
EOF
}

confirm ()
{
	printf "$QUESTION "
	printf "Do you want to continue? (Y/n) "
	read answer
	test -z "$answer" && return 0
	test "$answer" = "y" && return 0
	return 1
}

ok ()
{
    printf "$OK $*\n"
}

ko ()
{
    RETVAL=$?
    >&2 printf "$KO $*\n"
}

opterror ()
{
    >&2 printf "$ERROR $* ${BOLD}$pkgcmd${NC}\n"
}

com ()
{
    printf "[${CYANFG}COMMAND${NC}] ${BOLD}${GREENFG}$*${NC}\n"
	$* &&
    ok "Command ${BOLD}$pkgcmd${NC} executed successfully in ${BOLD}$distro${NC}." || ko "Command failed."
}

confirm_com ()
{
    printf "[${CYANFG}COMMAND${NC}] ${BOLD}${GREENFG}$*${NC}\n"
    confirm || exit 1
	$* &&
    ok "Command ${BOLD}$pkgcmd${NC} executed successfully in ${BOLD}$distro${NC}." || ko "Command failed."
}

nocom ()
{
    >&2 printf "[${YELLOWFG}NO COMMAND${NC}] ${YELLOWFG}${BOLD}${1}${NC}\n"
    exit 1
}

is_artix ()
{
    test -f /etc/artix-release && return 0
    return 1
}

is_artix ()
{
    test -f /etc/arch-release && return 0
    return 1
}

is_debian ()
{
    test -f /etc/debian_version && return 0
    return 1
}

is_gentoo ()
{
    test -f /etc/gentoo-release && return 0
    return 1
}

is_void ()
{
    test -f /etc/os-release && . /etc/os-release &&
		test "$ID" = "void" && return 0
    return 1
}


okdistro ()
{
    printf "$DISTRO Found: ${YELLOWFG}${BOLD}${1}${NC}\n"
}

kodistro ()
{
    >&2 printf "$DISTRO No Founded. Sorry\n"
	exit 1
}


if is_artix
then
	distro=Artix
    okdistro "$distro"
    cmd_add="pacman -S"
    cmd_merge="pacman -U"
    cmd_remove="pacman -Rsc"
    cmd_purge="pacman -Rsc"
    cmd_sync="pacman -Sy"
    cmd_upgrade="pacman -Syu"
    cmd_search="pacman -Ss"
    cmd_list="pacman -Ql"
    cmd_belongs="pacman -Qo"
    cmd_info="pacman -Si"
elif is_debian
then
	distro=Debian
    okdistro "$distro"
    cmd_add="apt-get install"
    cmd_merge="dpkg -i"
    cmd_remove="apt-get remove"
    cmd_purge="apt-get purge"
    cmd_sync="apt-get update"
    cmd_upgrade="apt-get upgrade"
    cmd_search="apt-cache search"
    cmd_list="dpkg -L"
    cmd_belongs="depkg -S"
    cmd_info="apt show"
elif is_gentoo
then
	distro=Gentoo
    okdistro "$distro"
	ko "Today $distro is not supported"; exit 1
elif is_void
then
	distro=Void
    okdistro "$distro"
	#ko "Today $distro is not supported"; exit 1
    cmd_add="xbps-install install"
    cmd_merge="dpkg -i"
    cmd_remove="xbps-remove"
    cmd_purge="xbps-remove -Oo"
    cmd_sync="xbps-install -S"
    cmd_upgrade="xbps-install -Su"
    cmd_search="xbps-query -Rs"
    cmd_list="dpkg -L"
    cmd_belongs="xbps-query -Ro"
    cmd_info="apt show"
else
    kodistro
fi

pkgcmd=$1
case $1 in
    a|ad|add) shift; confirm_com $cmd_add $*
    ;;
    m|me|mer|merg|merge)     shift; confirm_com $cmd_merge $*
    ;;
    r|re|rem|remo|remov|remove)  shift; confirm_com $cmd_remove $*
    ;;
    p|pu|pur|purg|purge)   shift; confirm_com $cmd_purge $*
    ;;
    s|sy|syn|sync)    shift; com $cmd_sync $*
    ;;
    u|up|upg|upgr|upgra|upgrad|upgrade) shift; com $cmd_upgrade $*
    ;;
    s|se|sea|sear|searc|search)  shift; com $cmd_search $*
    ;;
    l|l|li|lis|list)    shift; com $cmd_list $*
    ;;
    b|be|bel|belo|belon|belong|belongs) shift; com $cmd_belongs $*
    ;;
    i|in|inf|info)    shift; com $cmd_info $*
    ;;
    h|he|hel|help)    help; exit 0;;
    \?) opterror "Unknown option:"; exit 1;;
    :)  opterror "Missing option argument for"; exit 1;;
    *)  opterror "Unimplemented option:"; exit 1;;
esac

exit $RETVAL
