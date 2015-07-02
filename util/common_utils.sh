#!/bin/sh


pst_debug_echo "$BASH_SOURCE"

if [ -n "$(command -v column 2>/dev/null)" ] ; then
	alias tcat='column -t'
	function tless () {
		column -t "$@" | less -S ;
	}
fi


if [ -z "$(command -v md5sum 2>/dev/null)" ] && [ -n "$(command -v openssl 2>/dev/null)" ] ; then
	alias md5sum='openssl md5'
fi


if [ -n "$(command -v lsof 2>/dev/null)" ] ; then
	function netspy () {
		lsof -i -P +c 0 +M | grep -i "$1"
	}
fi


if [ -n "$(command -v ifconfig 2>/dev/null)" ] ; then
	alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

	if [ -n "$(command -v nmap 2>/dev/null)" ] ; then
		function lanmacs () {
			local myips=`myip`
			for ip in $myips ; do
				local a=`cut -f1-3 -d"." <(echo $ip)`
				local seg=$a".*"
				echo "-------------------------------------------------------------------------"
				echo "Finding Hosts in LAN segment: "$seg
				echo "-------------------------------------------------------------------------"
				sudo nmap -sP $seg
			done
		}
	fi
fi


# !!!!!!!!!!!!!!!!!!!! File/Directory Cleanup
# text editor artifacts
alias find~="find . -type f -name '*~' -ls"
alias cleanup~="find . -type f -name '*~' -ls -delete"
# OSX artifacts
alias findDS="find . -type f -name '.DS_Store' -ls"
alias cleanupDS="find . -type f -name '.DS_Store' -ls -delete"
# Windows artifacts
alias findThumbs="find . -type f -name 'Thumbs.db' -ls"
alias cleanupThumbs="find . -type f -name 'Thumbs.db' -ls -delete"
